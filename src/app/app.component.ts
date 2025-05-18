import { Component, NO_ERRORS_SCHEMA } from "@angular/core";
import { PageRouterOutlet, registerElement } from "@nativescript/angular";
import { DottedBorderView } from "./native-views/dotted-border-view";
import { PIPView } from "./native-views/pip-view";

registerElement("DottedBorderView", () => DottedBorderView);
registerElement("PIPView", () => PIPView);

@Component({
  selector: "ns-app",
  templateUrl: "./app.component.html",
  imports: [PageRouterOutlet],
  schemas: [NO_ERRORS_SCHEMA],
})
export class AppComponent {}
