import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MqttClientServiceService } from 'src/app/services/mqtt-client.service';

@Component({
  selector: 'app-acertou',
  templateUrl: './acertou.component.html',
  styleUrls: ['./acertou.component.css']
})
export class AcertouComponent implements OnInit {
  mqttservice: MqttClientServiceService;

  constructor(private router: Router, mqttservice: MqttClientServiceService) { 
    this.mqttservice = mqttservice
  }

  ngOnInit(): void {
    setTimeout(() => {
      this.mqttservice.doPublish("reset/", '1')
    }, 1000)
    
  }

  jogarNovamente(){
    this.mqttservice.doPublish("reset/", "1")
    
    setTimeout(() => {
      this.mqttservice.doPublish("iniciar/", "1")
    }, 150)

    this.router.navigateByUrl("modo")
  }

  voltarAoMenu(){
    this.mqttservice.doPublish("reset/", "1")
    this.router.navigateByUrl("/inicio")
  }

}
