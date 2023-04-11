import { Injectable, Output, EventEmitter } from '@angular/core';

@Injectable({
    providedIn: 'root'
  })
export class ListenerService {
    modo?: number;
    dificuldade?: string;
    @Output() amostrarGreen = new EventEmitter();
    @Output() amostrarRed = new EventEmitter();
    @Output() amostrarBlue = new EventEmitter();
    @Output() amostrarYellow = new EventEmitter();
    @Output() ganhou = new EventEmitter();
    @Output() perdeu = new EventEmitter();


    callback(msg: string, topic: string) {
      if (topic == "leds/") {
        this.callbackLeds(msg);
      }
      if (topic == "ganhou/") {
        this.callbackGanhou(msg);
      }
      if (topic == "perdeu/") {
        this.callbackPerdeu(msg);
      }
    }

    callbackLeds(msg: string) {
      if (msg == "0001") {
        this.amostrarGreen.emit();
      }
      if (msg == "0010") {
        this.amostrarRed.emit();
      }
      if (msg == "0100") {
        this.amostrarBlue.emit();
      }
      if (msg == "1000") {
        this.amostrarYellow.emit();
      }
    }

    callbackGanhou(msg: string) {
      if (msg == '1') {
        this.ganhou.emit();
      }
    }

    callbackPerdeu(msg: string) {
      if (msg == '1') {
        this.perdeu.emit();
      }
    }
}