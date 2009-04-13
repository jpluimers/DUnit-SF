unit ParticleUnit;

interface

type
  TVector3D = record
    X: currency;
    Y: currency;
    Z: currency;
  end;

  TParticle3D = class(TObject)
  private
    FY: currency;
    FX: currency;
    FZ: currency;
    FVelocity: TVector3D;
    procedure SetX(const Value: currency);
    procedure SetY(const Value: currency);
    procedure SetZ(const Value: currency);
    procedure SetVelocity(const Value: TVector3D);
  public
    procedure Move(Magnitude: currency);
    property Velocity: TVector3D read FVelocity write SetVelocity;
    property X: currency read FX write SetX;
    property Y: currency read FY write SetY;
    property Z: currency read FZ write SetZ;
  end;

implementation

{ TParticle3D }

procedure TParticle3D.Move(Magnitude: currency);
begin
  FX := FX + (FVelocity.X * Magnitude);
  FY := FY + (FVelocity.Y * Magnitude);
  FZ := FZ + (FVelocity.Z * Magnitude);
end;

procedure TParticle3D.SetVelocity(const Value: TVector3D);
begin
  FVelocity := Value;
end;

procedure TParticle3D.SetX(const Value: currency);
begin
  FX := Value;
end;

procedure TParticle3D.SetY(const Value: currency);
begin
  FY := Value;
end;

procedure TParticle3D.SetZ(const Value: currency);
begin
  FZ := Value;
end;

end.
