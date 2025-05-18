import { Routes } from '@angular/router';
import { PIPExampleComponent } from './pip-example.component'

export const routes: Routes = [
  { path: '', redirectTo: '/example-pip', pathMatch: 'full' },
  { path: 'example-pip', component: PIPExampleComponent },
];
