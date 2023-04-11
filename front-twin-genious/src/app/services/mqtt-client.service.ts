import { ListenerService } from './listener.service';
import { Injectable } from '@angular/core';
import {
    IMqttMessage,
    IMqttServiceOptions,
    MqttService,
    IPublishOptions,
  } from 'ngx-mqtt';
  import { IClientSubscribeOptions } from 'mqtt-browser';
  import { Subscription } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MqttClientServiceService {
  listener: ListenerService;

  constructor(private _mqttService: MqttService, listener: ListenerService) {
    this.client = this._mqttService;
    this.listener = listener;
  }
  private curSubscription: Subscription | undefined;
  connection = {
    hostname: '89027d54046045d3954ec8a3d6c7c9cf.s2.eu.hivemq.cloud',
    port: 8884,
    path: '/mqtt',
    clean: true, 
    reconnectPeriod: 1,
    clientId: 'mqttx_597046f4',
    username: 'java-client',
    password: 'garsoft-java',
    protocol: 'wss',
    }
  receiveNews = '';
  qosList = [
    { label: 0, value: 0 },
    { label: 1, value: 1 },
    { label: 2, value: 2 },
  ];
  client: MqttService | undefined;
  isConnection = false;
  subscribeSuccess = false;

  createConnection() {
    try {
      this.client?.connect(this.connection as IMqttServiceOptions)
    } catch (error) {
      console.log('mqtt.connect error', error);
    }
    this.client?.onConnect.subscribe(() => {
      this.isConnection = true
      console.log('Connection succeeded!');
    });
    this.client?.onError.subscribe((error: any) => {
      this.isConnection = false
      console.log('Connection failed', error);
    });
    this.client?.onMessage.subscribe((packet: any) => {
      console.log(`msg=${packet.payload.toString()} topic=${packet.topic.toString()}`)
      this.listener.callback(packet.payload.toString(), packet.topic.toString());
    })
  }

  doSubscribe(topicname: string) {
    var subscription = {
      topic: topicname,
      qos: 0,
    };
    const { topic, qos } = subscription;
    this.curSubscription = this.client?.observe(topic, { qos } as IClientSubscribeOptions).subscribe((message: IMqttMessage) => {
      this.subscribeSuccess = true
    })
  }

  doPublish(topicname: string, msg: string) {
    var publish = {
      topic: topicname,
      qos: 0,
      payload: msg,
    };
    const { topic, qos, payload } = publish;
    this.client?.unsafePublish(topic, payload, { qos } as IPublishOptions)
    console.log(publish)
  }
}
