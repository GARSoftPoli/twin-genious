import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DificuldadeComponent } from './components/dificuldade/dificuldade.component';
import { GeniousGameComponent } from './components/genious-game/genious-game.component';
import { InitialComponent } from './components/initial/initial.component';
import { ModoComponent } from './components/modo/modo.component';
import { AcertouComponent } from './components/acertou/acertou.component';
import { ErrouComponent } from './components/errou/errou.component';
import { LoginComponent } from './components/login/login.component';

const routes: Routes = [
  {path: '', component: LoginComponent},
  {path: 'inicio', component: InitialComponent},
  {path: 'jogo', component: GeniousGameComponent},
  {path: 'modo', component: ModoComponent},
  {path: 'dificuldade', component: DificuldadeComponent},
  {path: 'acerto', component: AcertouComponent},
  {path: 'erro', component: ErrouComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
