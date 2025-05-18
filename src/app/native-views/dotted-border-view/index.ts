import { Utils, View } from "@nativescript/core";

export class DottedBorderView extends View {
  createNativeView() {
    const view = UIView.new();
    let borderLayer = CAShapeLayer.new();
    borderLayer.lineWidth = 1;
    borderLayer.strokeColor = UIColor.systemOrangeColor.CGColor;
    borderLayer.lineDashPattern = Utils.ios.collections.jsArrayToNSArray([
      8, 8,
    ]);
    const bounds = CGRectMake(0, 0, 120, 80);
    borderLayer.frame = bounds;
    borderLayer.fillColor = null;

    borderLayer.path = UIBezierPath.bezierPathWithRoundedRectCornerRadius(
      bounds,
      16
    ).CGPath;

    view.layer.addSublayer(borderLayer);
    return view;
  }
}
