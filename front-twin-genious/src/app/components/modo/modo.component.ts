import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MqttClientServiceService } from 'src/app/services/mqtt-client.service';

@Component({
  selector: 'app-modo',
  templateUrl: './modo.component.html',
  styleUrls: ['./modo.component.css']
})
export class ModoComponent implements OnInit {
  mqttservice: MqttClientServiceService;
  modo?: number;
  
  constructor(private router: Router, mqttservice: MqttClientServiceService) { 
    this.mqttservice = mqttservice;
  }

  ngOnInit(): void {
  }

  setModo(modo: number) {
    this.modo = modo;
    if (modo == 1) {
      this.mqttservice.doPublish('botoes/', '0001');
    }
    if (modo == 2) {
      this.mqttservice.doPublish('botoes/', '0010');
    }
  }

  dificuldade(){
    this.router.navigateByUrl("/dificuldade");
  }

}
