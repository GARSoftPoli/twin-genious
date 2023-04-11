import { ComponentFixture, TestBed } from '@angular/core/testing';

import { GeniousGameComponent } from './genious-game.component';

describe('GeniousGameComponent', () => {
  let component: GeniousGameComponent;
  let fixture: ComponentFixture<GeniousGameComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ GeniousGameComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(GeniousGameComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
