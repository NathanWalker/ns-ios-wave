import { Utils, View } from "@nativescript/core";

export class PIPView extends View {
  createNativeView() {
    const view = UIView.new();
    let gradient = CAGradientLayer.new();
    gradient.colors = Utils.ios.collections.jsArrayToNSArray([
      UIColor.systemOrangeColor.CGColor,
      UIColor.systemRedColor.CGColor,
    ]);
    gradient.cornerRadius = 16;
    gradient.cornerCurve = kCACornerCurveContinuous;
    gradient.frame = CGRectMake(0, 0, 120, 80);
    view.layer.insertSublayerAtIndex(gradient, 0);

    view.layer.shadowColor = UIColor.blackColor.CGColor;
    view.layer.shadowOpacity = 0.2;
    view.layer.shadowRadius = 5;
    view.layer.shadowOffset = CGSizeMake(0, 3);
    return view;
  }
}
