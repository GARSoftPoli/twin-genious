import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ErrouComponent } from './errou.component';

describe('ErrouComponent', () => {
  let component: ErrouComponent;
  let fixture: ComponentFixture<ErrouComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ErrouComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ErrouComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
