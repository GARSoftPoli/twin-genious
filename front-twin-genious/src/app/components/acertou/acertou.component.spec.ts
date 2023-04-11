import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AcertouComponent } from './acertou.component';

describe('AcertouComponent', () => {
  let component: AcertouComponent;
  let fixture: ComponentFixture<AcertouComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AcertouComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AcertouComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
