import { ListenerService } from './../../services/listener.service';
import { Component, OnInit, EventEmitter, Output } from '@angular/core';
import { Router } from '@angular/router';
import { MqttClientServiceService } from 'src/app/services/mqtt-client.service';

@Component({
  selector: 'app-genious-game',
  templateUrl: './genious-game.component.html',
  styleUrls: ['./genious-game.component.css']
})
export class GeniousGameComponent implements OnInit {
  mqttservice: MqttClientServiceService;
  listenerService: ListenerService;
  jogada?: string;
  greenActive?: boolean;
  redActive?: boolean;
  blueActive?: boolean;
  yellowActive?: boolean;

  constructor(private router: Router, mqttservice: MqttClientServiceService, listener: ListenerService) { 
    this.mqttservice = mqttservice;
    this.listenerService = listener;
    this.listenerService.amostrarGreen.subscribe( () => this.amostrarPalavra("green") );
    this.listenerService.amostrarRed.subscribe( () => this.amostrarPalavra("red") );
    this.listenerService.amostrarBlue.subscribe( () => this.amostrarPalavra("blue") );
    this.listenerService.amostrarYellow.subscribe( () => this.amostrarPalavra("yellow") );
    this.listenerService.ganhou.subscribe( () => this.ganhouJogo() );
    this.listenerService.perdeu.subscribe( () => this.perdeuJogo() );
  }

  _gui = {
    pads: document.querySelectorAll(".game__pad")
  }

  ngOnInit(): void {

  }

  acenderPad(event: Event){
    // console.log("acendeu");
    (event.target as Element).classList.add("game__pad--active");

  }

  apagarPad(event: Event){
    // console.log("apagar");
    (event.target as Element).classList.remove("game__pad--active");
  }

  setJogada(jogada: string) {
    this.jogada = jogada;
    console.log(jogada)
    if (jogada == "green") {
      this.mqttservice.doPublish('botoes/', '0001');
    }
    if (jogada == "red") {
      this.mqttservice.doPublish('botoes/', '0010');
    }
    if (jogada == "blue") {
      this.mqttservice.doPublish('botoes/', '0100');
    }
    if (jogada == "yellow") {
      this.mqttservice.doPublish('botoes/', '1000');
    }
  }

  amostrarPalavra(palavra: string) {
    if (palavra == "green") {
      this.greenActive = true;
      setTimeout(() => {
        this.greenActive = false;
      }, 1000);
    }
    if (palavra == "red") {
      this.redActive = true;
      setTimeout(() => {
        this.redActive = false;
      }, 1000);
    }
    if (palavra == "blue") {
      this.blueActive = true;
      setTimeout(() => {
        this.blueActive = false;
      }, 1000);
    }
    if (palavra == "yellow") {
      this.yellowActive = true;
      setTimeout(() => {
        this.yellowActive = false;
      }, 1000);
    }
  }

  ganhouJogo() {
    console.log("GANHOU");
    this.router.navigateByUrl("acerto")
  }

  perdeuJogo() {
    console.log("PERDEU");
    this.router.navigateByUrl("erro")
  }

  acionaReset(){
    this.mqttservice.doPublish("reset/", "1")
    setTimeout(() => {
      this.router.navigateByUrl("/inicio")

    }, 10)
    
  }
}
