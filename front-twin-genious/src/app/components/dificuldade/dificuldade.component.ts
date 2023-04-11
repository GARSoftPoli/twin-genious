import { Component, OnInit } from '@angular/core';
import { Route, Router } from '@angular/router';
import { MqttClientServiceService } from 'src/app/services/mqtt-client.service';

@Component({
  selector: 'app-dificuldade',
  templateUrl: './dificuldade.component.html',
  styleUrls: ['./dificuldade.component.css']
})
export class DificuldadeComponent implements OnInit {
  mqttservice: MqttClientServiceService;
  dificuldade?: string;

  constructor(private router: Router, mqttservice: MqttClientServiceService) { 
    this.mqttservice = mqttservice;
  }

  ngOnInit(): void {
  }

  setDificuldade(dificuldade: string) {
    this.dificuldade = dificuldade;
    if (dificuldade == "facil") {
      this.mqttservice.doPublish('botoes/', '0001');
    }
    if (dificuldade == "medio") {
      this.mqttservice.doPublish('botoes/', '0010');
    }
    if (dificuldade == "dificil") {
      this.mqttservice.doPublish('botoes/', '0100');
    }    
  }

  startGame(){
    this.router.navigateByUrl("/jogo");
  }

}
