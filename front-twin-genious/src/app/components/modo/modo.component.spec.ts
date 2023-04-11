import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ModoComponent } from './modo.component';

describe('ModoComponent', () => {
  let component: ModoComponent;
  let fixture: ComponentFixture<ModoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ModoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ModoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
