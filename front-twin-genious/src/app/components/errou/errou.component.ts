import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MqttClientServiceService } from 'src/app/services/mqtt-client.service';

@Component({
  selector: 'app-errou',
  templateUrl: './errou.component.html',
  styleUrls: ['./errou.component.css']
})
export class ErrouComponent implements OnInit {
  mqttservice: MqttClientServiceService;

  constructor(private router: Router, mqttservice: MqttClientServiceService) {
    this.mqttservice = mqttservice
   }

  ngOnInit(): void {
    this.mqttservice.doPublish("reset/", '1')  
  }

  jogarNovamente(){
    this.mqttservice.doPublish("reset/", '1')
    
    setTimeout(() => {
      this.mqttservice.doPublish("iniciar/", '1')
    }, 150)

    this.router.navigateByUrl("modo")
  }

  voltarAoMenu(){
    console.log('reset')
    this.mqttservice.doPublish("reset/", '1')
    this.router.navigateByUrl("/inicio")
  }
}
