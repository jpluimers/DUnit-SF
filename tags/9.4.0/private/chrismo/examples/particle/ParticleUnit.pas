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
    FMaxX: currency;
    FMinZ: currency;
    FMaxY: currency;
    FMinX: currency;
    FMinY: currency;
    FMaxZ: currency;
    FRandomMaxPos: currency;
    FRandomMaxVelocity: currency;
    function GetParticleCount: integer;
    function GetParticle(Index: integer): TParticle3D;
    procedure SetMaxX(const Value: currency);
    procedure SetMaxY(const Value: currency);
    procedure SetMaxZ(const Value: currency);
    procedure SetMinX(const Value: currency);
    procedure SetMinY(const Value: currency);
    procedure SetMinZ(const Value: currency);
    procedure SetRandomMaxPos(const Value: currency);
    procedure SetRandomMaxVelocity(const Value: currency);
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddParticle(AParticle: TParticle3D);
    procedure AddRandomParticle;
    procedure Step(IncAmount: currency);

    property MinX: currency read FMinX write SetMinX;
    property MaxX: currency read FMaxX write SetMaxX;
    property MinY: currency read FMinY write SetMinY;
    property MaxY: currency read FMaxY write SetMaxY;
    property MinZ: currency read FMinZ write SetMinZ;
    property MaxZ: currency read FMaxZ write SetMaxZ;
    property ParticleCount: integer read GetParticleCount;
    property Particles[Index: integer]: TParticle3D read GetParticle;
    property RandomMaxPos: currency read FRandomMaxPos write SetRandomMaxPos;
    property RandomMaxVelocity: currency read FRandomMaxVelocity write SetRandomMaxVelocity;
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
  AParticle.X := Random(Round(FRandomMaxPos * 2)) - FRandomMaxPos;
  AParticle.Y := Random(Round(FRandomMaxPos * 2)) - FRandomMaxPos;
  AParticle.Z := Random(Round(FRandomMaxPos * 2)) - FRandomMaxPos;
  AVector.X := Random(Round(FRandomMaxVelocity * 2)) - FRandomMaxVelocity;
  AVector.Y := Random(Round(FRandomMaxVelocity * 2)) - FRandomMaxVelocity;
  AVector.Z := Random(Round(FRandomMaxVelocity * 2)) - FRandomMaxVelocity;
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

procedure TParticleSystem3D.SetMaxX(const Value: currency);
begin
  FMaxX := Value;
end;

procedure TParticleSystem3D.SetMaxY(const Value: currency);
begin
  FMaxY := Value;
end;

procedure TParticleSystem3D.SetMaxZ(const Value: currency);
begin
  FMaxZ := Value;
end;

procedure TParticleSystem3D.SetMinX(const Value: currency);
begin
  FMinX := Value;
end;

procedure TParticleSystem3D.SetMinY(const Value: currency);
begin
  FMinY := Value;
end;

procedure TParticleSystem3D.SetMinZ(const Value: currency);
begin
  FMinZ := Value;
end;

procedure TParticleSystem3D.SetRandomMaxPos(const Value: currency);
begin
  FRandomMaxPos := Value;
end;

procedure TParticleSystem3D.SetRandomMaxVelocity(const Value: currency);
begin
  FRandomMaxVelocity := Value;
end;

procedure TParticleSystem3D.Step(IncAmount: currency);
var
  i: integer;

  procedure AdjustXBounds(AParticle: TParticle3D);
  var
    AVector: TVector3D;
  begin
    AVector := AParticle.Velocity;
    if AParticle.X < FMinX then
      AVector.X := AVector.X + (Abs(AParticle.X - FMinX));

    if AParticle.X > FMaxX then
      AVector.X := AVector.X - (Abs(AParticle.X - FMaxX));
    AParticle.Velocity := AVector;
  end;

  procedure AdjustYBounds(AParticle: TParticle3D);
  var
    AVector: TVector3D;
  begin
    AVector := AParticle.Velocity;
    if AParticle.Y < FMinY then
      AVector.Y := AVector.Y + (Abs(AParticle.Y - FMinY));

    if AParticle.Y > FMaxY then
      AVector.Y := AVector.Y - (Abs(AParticle.Y - FMaxY));
    AParticle.Velocity := AVector;
  end;

  procedure AdjustZBounds(AParticle: TParticle3D);
  var
    AVector: TVector3D;
  begin
    AVector := AParticle.Velocity;
    if AParticle.Z < FMinZ then
      AVector.Z := AVector.Z + (Abs(AParticle.Z - FMinZ));

    if AParticle.Z > FMaxZ then
      AVector.Z := AVector.Z - (Abs(AParticle.Z - FMaxZ));
    AParticle.Velocity := AVector;
  end;
begin
  for i := 0 to FParticles.Count - 1 do
  begin
    AdjustXBounds(FParticles[i]);
    AdjustYBounds(FParticles[i]);
    AdjustZBounds(FParticles[i]);
    Particles[i].Move(IncAmount);
  end;
end;

end.
