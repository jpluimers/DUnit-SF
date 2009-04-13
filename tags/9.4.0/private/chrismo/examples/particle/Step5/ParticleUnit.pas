unit ParticleUnit;

interface

uses
  SysUtils, Classes;

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

  TParticleSystem3D = class(TObject)
  private
    FParticles: TList;
    function GetParticleCount: integer;
    function GetParticle(Index: integer): TParticle3D;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddParticle(AParticle: TParticle3D);
    procedure AddRandomParticle;
    procedure Step(IncAmount: currency); 

    property ParticleCount: integer read GetParticleCount;
    property Particles[Index: integer]: TParticle3D read GetParticle;
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

{ TParticleSystem3D }

procedure TParticleSystem3D.AddParticle(AParticle: TParticle3D);
begin
  FParticles.Add(AParticle);
end;

procedure TParticleSystem3D.AddRandomParticle;
var
  AParticle: TParticle3D;
  AVector: TVector3D;
begin
  AParticle := TParticle3D.Create;
  AParticle.X := Random(10) - 5;
  AParticle.Y := Random(10) - 5;
  AParticle.Z := Random(10) - 5;
  AVector.X := Random(10) - 5;
  AVector.Y := Random(10) - 5;
  AVector.Z := Random(10) - 5;
  AParticle.Velocity := AVector;
  FParticles.Add(AParticle);
end;

constructor TParticleSystem3D.Create;
begin
  FParticles := TList.Create;
end;

destructor TParticleSystem3D.Destroy;
begin
  FParticles.Free;
end;

function TParticleSystem3D.GetParticle(Index: integer): TParticle3D;
begin
  Result := nil;
  if Index < FParticles.Count then
    Result := TParticle3D(FParticles[Index]);
end;

function TParticleSystem3D.GetParticleCount: integer;
begin
  Result := FParticles.Count;
end;

procedure TParticleSystem3D.Step(IncAmount: currency);
var
  i: integer;
begin
  for i := 0 to FParticles.Count - 1 do
    Particles[i].Move(IncAmount);
end;

end.
