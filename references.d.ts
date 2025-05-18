/// <reference path="./node_modules/@nativescript/types/index.d.ts" />

declare class PIPWaveAnimator extends NSObject {

	static alloc(): PIPWaveAnimator; // inherited from NSObject

	static new(): PIPWaveAnimator; // inherited from NSObject

	pathView: PathView;

	static readonly shared: PIPWaveAnimator;

	handlePanWithSenderView(sender: UIPanGestureRecognizer, view: UIView): void;
}