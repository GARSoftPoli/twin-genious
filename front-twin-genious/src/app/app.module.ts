import { ListenerService } from './services/listener.service';
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { GeniousGameComponent } from './components/genious-game/genious-game.component';
import { InitialComponent } from './components/initial/initial.component';
import { ModoComponent } from './components/modo/modo.component';
import { DificuldadeComponent } from './components/dificuldade/dificuldade.component';


import { IMqttServiceOptions, MqttModule } from 'ngx-mqtt';
import { MqttClientServiceService } from './services/mqtt-client.service';
import { AcertouComponent } from './components/acertou/acertou.component';
import { ErrouComponent } from './components/errou/errou.component';
import { LoginComponent } from './components/login/login.component';

export const connection: IMqttServiceOptions = {
  hostname: '89027d54046045d3954ec8a3d6c7c9cf.s2.eu.hivemq.cloud',
  port: 8884,
  path: '/mqtt',
  clean: true,
  reconnectPeriod: 1,
  clientId: 'mqttx_597046f4',
  username: 'java-client',
  password: 'garsoft-java',
  protocol: 'wss',
  connectOnCreate: false,
}
@NgModule({
  declarations: [
    AppComponent,
    GeniousGameComponent,
    InitialComponent,
    ModoComponent,
    DificuldadeComponent,
    AcertouComponent,
    ErrouComponent,
    LoginComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MqttModule.forRoot(connection),
    FormsModule
  ],
  providers: [
    MqttClientServiceService,
    ListenerService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
