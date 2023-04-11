import { Component, OnInit } from '@angular/core';
import {NgForm} from '@angular/forms';
import { Router } from '@angular/router';
import { MqttClientServiceService } from 'src/app/services/mqtt-client.service';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  mqttservice: MqttClientServiceService

  constructor(private router: Router, mqttservice: MqttClientServiceService) { 
    this.mqttservice = mqttservice;
  }

  ngOnInit(): void {
  }

  onSubmit(value: any){
    if(value.username=="admin" && value.password=="garsoft2022"){
      console.log("LOGAR")
      if(!this.mqttservice.isConnection){
        this.mqttservice.createConnection();
        this.mqttservice.doSubscribe('leds/');
        this.mqttservice.doSubscribe('ganhou/');
        this.mqttservice.doSubscribe('perdeu/');
      }
      this.router.navigateByUrl("/inicio")
    }
    else{
      alert("Credenciais inválidas")
    }
  }

}
