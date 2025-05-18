import { Component, NO_ERRORS_SCHEMA } from "@angular/core";
import { NativeScriptCommonModule } from "@nativescript/angular";
import { AbsoluteLayout, EventData, PanGestureEventData, Screen, View } from "@nativescript/core";

@Component({
  selector: "ns-pip-example",
  templateUrl: "./pip-example.component.html",
  imports: [NativeScriptCommonModule],
  schemas: [NO_ERRORS_SCHEMA],
})
export class PIPExampleComponent {
  container: AbsoluteLayout;
  pipWaveAnimator = PIPWaveAnimator.shared;

  pan(args: PanGestureEventData) {
    const recognizer = args.ios as UIPanGestureRecognizer;
    this.pipWaveAnimator.handlePanWithSenderView(
      recognizer,
      this.container.ios as UIView
    );
  }

  loaded(args: EventData) {
    const view = args.object as View;
    view.translateX = 10;
    view.translateY = 10;
  }

  loadedContainer(args: EventData) {
    this.container = args.object as AbsoluteLayout;
  }

  loadedDropZone(args: EventData, index: number) {
    const view = args.object as View;
    view.scaleX = view.scaleY = 0.9;
    switch (index) {
      case 1:
        view.translateX = 25;
        view.translateY = 40;
        break;
      case 2:
        view.translateX = Screen.mainScreen.widthDIPs - 129;
        view.translateY = 40;
        break;
      case 3:
        view.translateX = 25;
        view.translateY = Screen.mainScreen.heightDIPs - 188;
        break;
      case 4:
        view.translateX = Screen.mainScreen.widthDIPs - 129;
        view.translateY = Screen.mainScreen.heightDIPs - 188;
        break;
    }
  }
}
