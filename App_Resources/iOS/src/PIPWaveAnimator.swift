//
//  Adapted from PictureInPictureViewController.swift
//  Wave
//
//  Copyright (c) 2022 Janum Trivedi.
//  Customized by Nathan Walker on 2025-05-17.
//

import Foundation
import UIKit
import SwiftUI
import Wave

@objcMembers
open class PIPWaveAnimator: NSObject {
    public static let shared = PIPWaveAnimator()

    /// A tighter spring used when dragging the PiP view around.
    let interactiveSpring = Spring(dampingRatio: 0.8, response: 0.26)

    /// A looser spring used to animate the PiP view to its final location after dragging ends.
    let animatedSpring = Spring(dampingRatio: 0.68, response: 0.8)

    /// In order to draw the path that the PiP view takes when animating to its final destination,
    /// we need the intermediate spring values. Use a separate `CGPoint` animator to get these values.
    lazy var positionAnimator = SpringAnimator<CGPoint>(spring: animatedSpring)

    var pathView: PathView?

    private var initialTouchLocation: CGPoint = .zero

    public func handlePan(sender: UIPanGestureRecognizer, view: UIView) {
        if (pathView == nil) {
            // Create the path view for the visualization of the path.
            pathView = PathView(frame: view.bounds)
            pathView?.backgroundColor = .clear
            pathView?.isUserInteractionEnabled = false
            view.addSubview(pathView!)
        }
        
        guard let pipView = sender.view else {
            return
        }

        let touchLocation = sender.location(in: view)
        let touchTranslation = sender.translation(in: view)
        let touchVelocity = sender.velocity(in: view)

        if sender.state == .began {
            // Mark the view's initial position.
            initialTouchLocation = pipView.center

            // Invalidate the position animator.
            positionAnimator.valueChanged = nil
            pathView?.reset()
        }

        switch sender.state {
        case .began, .changed:

            let targetPiPViewCenter = CGPoint(
                x: initialTouchLocation.x + touchTranslation.x,
                y: initialTouchLocation.y + touchTranslation.y
            )

            // We want the dragged view to closely follow the user's touch (not exactly 1:1, but close).
            // So animating using the `interactiveSpring` that has a lower `response` value.
            // See `Spring.swift` for more information.

            Wave.animate(withSpring: interactiveSpring) {
                // Just update the view's `animator.center` – that's it!
                pipView.animator.center = targetPiPViewCenter
            }

        case .ended, .cancelled:
            // The gesture ended, so figure out where the PiP view should ultimately land.
            let pipViewDestination = targetCenter(pipView: pipView, view: view, currentPosition: touchLocation, velocity: touchVelocity)

            // The `animatedSpring` is looser and takes a longer time to settle, so use that to animate the final position.
            //
            // Finally "inject" the pan gesture's lift-off velocity into the animation.
            // That `gestureVelocity` parameter will affect the `center` animation.
            Wave.animate(withSpring: animatedSpring, gestureVelocity: touchVelocity) {
                pipView.animator.center = pipViewDestination
            }

            // This position animation runs the exact same spring animation as the above block (i.e. `pipView.animator.center = ...`)
            // We run this to get the intermediate spring values, such that we can draw the view's animation path.
            positionAnimator.spring = animatedSpring
            positionAnimator.value = pipView.center             // The current, presentation value of the view.
            positionAnimator.target = pipView.animator.center   // The target center that we just set above.
            positionAnimator.velocity = touchVelocity

            positionAnimator.valueChanged = { [weak self] location in
                self!.pathView?.add(location)
            }

            positionAnimator.start()

        default:
            break
        }
    }

    private func targetCenter(pipView: UIView, view: UIView, currentPosition: CGPoint, velocity: CGPoint) -> CGPoint {
        let size = pipView.bounds.size

        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height

        var projectedPosition = project(point: currentPosition, velocity: velocity)

        projectedPosition.x = clip(value: projectedPosition.x, lower: 1, upper: screenWidth - 1)
        projectedPosition.y = clip(value: projectedPosition.y, lower: 1, upper: screenHeight - 1)

        let topLeft = CGRect(x: 0, y: 0, width: screenWidth / 2.0, height: screenHeight / 2.0)
        let topRight = CGRect(x: screenWidth / 2.0, y: 0, width: screenWidth / 2.0, height: screenHeight / 2.0)

        let bottomLeft = CGRect(x: 0, y: screenHeight / 2.0, width: screenWidth / 2.0, height: screenHeight / 2.0)
        let bottomRight = CGRect(x: screenWidth / 2.0, y: screenHeight / 2.0, width: screenWidth / 2.0, height: screenHeight / 2.0)

        var origin: CGPoint = .zero

        let marginX = 25.0
        let marginY = marginX

        if topLeft.contains(projectedPosition) {
            origin = CGPoint(x: 11, y: marginY)
        } else if topRight.contains(projectedPosition) {
            origin = CGPoint(x: (view.bounds.width - size.width - marginX), y: marginY)
        } else if bottomLeft.contains(projectedPosition) {
            origin = CGPoint(x: 11, y: (view.bounds.height - size.height - marginY))
        } else if bottomRight.contains(projectedPosition) {
            origin = CGPoint(x: (view.bounds.width - size.width - marginX), y: (view.bounds.height - size.height - marginY))
        }

        let center = CGPoint(x: origin.x + size.width / 2.0, y: origin.y + size.height / 2.0)

        return center
    }
}

class PathView: UIView {

    private var points: [CGPoint] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    func add(_ point: CGPoint) {
        if points.count > 300 {
            points.removeFirst()
        }
        points.append(point)
    }

    func reset() {
        points.removeAll()
        setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        isUserInteractionEnabled = false
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        guard let firstPoint = points.first else {
            return
        }

        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        context.beginPath()

        context.move(to: firstPoint)

        points.forEach {
            context.addLine(to: $0)
        }

        context.setLineCap(.square)
        context.setStrokeColor(UIColor.systemOrange.cgColor)
        context.setLineWidth(2)
        context.strokePath()
        context.restoreGState()
    }
}

extension DragGesture.Value {

    internal var velocity: CGSize {
        let valueMirror = Mirror(reflecting: self)
        for valueChild in valueMirror.children {
            if valueChild.label == "velocity" {
                let velocityMirror = Mirror(reflecting: valueChild.value)
                for velocityChild in velocityMirror.children {
                    if velocityChild.label == "valuePerSecond" {
                        if let velocity = velocityChild.value as? CGSize {
                            return velocity
                        }
                    }
                }
            }
        }
        fatalError("Unable to retrieve velocity from \(Self.self)")
    }
}