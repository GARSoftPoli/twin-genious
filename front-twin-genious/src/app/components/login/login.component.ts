import { Component, OnInit } from '@angular/core';
import {NgForm} from '@angular/forms';
import { Router } from '@angular/router';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(private router: Router) { }

  ngOnInit(): void {
  }

  onSubmit(value: any){
    if(value.username=="admin" && value.password=="garsoft2022"){
      console.log("LOGAR")
      this.router.navigateByUrl("/inicio")
    }
    else{
      alert("Credenciais inválidas")
    }
  }

}
