unit ParticleUnitTest;

interface

uses
  TestFramework, ParticleUnit;

type
  TTestParticle = class(TTestCase)
  private
    FParticle: TParticle3D;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestParticle;
  end;

  TTestParticleSystem = class(TTestCase)
  private
    FPSystem: TParticleSystem3D;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestAddParticle;
    procedure TestBounds;
    procedure TestMoveSystem;

  end;

  function Suite: ITestSuite;

implementation

function Suite: ITestSuite;
var
  ATestSuite: TTestSuite;
begin
  ATestSuite := TTestSuite.Create('Particle test suite');
  ATestSuite.AddTests(TTestParticle);
  ATestSuite.AddTests(TTestParticleSystem);
  Result := ATestSuite;
end;

{ TTestParticle }

procedure TTestParticle.Setup;
begin
  FParticle := TParticle3D.Create;
end;

procedure TTestParticle.TearDown;
begin
  FParticle.Free;
end;

procedure TTestParticle.TestParticle;
var
  AVector: TVector3D;
begin
  assert(FParticle.X = 0);
  assert(FParticle.Y = 0);
  assert(FParticle.Z = 0);
  FParticle.X := 5;
  FParticle.Y := 5;
  FParticle.Z := 5;
  AVector.X := 1;
  AVector.Y := 1;
  AVector.Z := 1;
  FParticle.Velocity := AVector;
  FParticle.Move(1);
  assert(FParticle.X = 6.0);
  assert(FParticle.Y = 6.0);
  assert(FParticle.Z = 6.0);
end;

{ TTestParticleSystem }

procedure TTestParticleSystem.Setup;
begin
  FPSystem := TParticleSystem3D.Create;
end;

procedure TTestParticleSystem.TearDown;
begin
  FPSystem.Free;
end;

procedure TTestParticleSystem.TestAddParticle;
begin
  assert(FPSystem.ParticleCount = 0);
  assert(FPSystem.Particles[0] = nil);
  FPSystem.AddRandomParticle;
  assert(FPSystem.ParticleCount = 1);
  assert(FPSystem.Particles[0] <> nil);
end;

procedure TTestParticleSystem.TestBounds;
var
  AParticle: TParticle3D;
  AVector: TVector3D;
begin
  FPSystem.MinX := -4;
  FPSystem.MaxX := 4;
  FPSystem.MinY := -4;
  FPSystem.MaxY := 4;
  FPSystem.MinZ := -4;
  FPSystem.MaxZ := 34;
  AParticle := TParticle3D.Create;
  try
    AParticle.X := 0;
    AParticle.Y := 0;
    AParticle.Z := 0;
    AVector.X := 0;
    AVector.Y := 0;
    AVector.Z := 0;
    AParticle.Velocity := AVector;
    FPSystem.AddParticle(AParticle);
    FPSystem.Step(1);
    assert(AParticle.X = 0);
    assert(AParticle.Y = 0);
    assert(AParticle.Z = 0);

    AParticle.X := 5;
    AParticle.Y := 5;
    AParticle.Z := -5;
    FPSystem.Step(1);
    assert(AParticle.X = 4);
    assert(AParticle.Y = 4);
    assert(AParticle.Z = -4);
  finally
    AParticle.Free;
  end;
end;

procedure TTestParticleSystem.TestMoveSystem;
var
  AParticle: TParticle3D;
  BParticle: TParticle3D;
  AVector: TVector3D;

  procedure DoAsserts(XParticle: TParticle3D);
  begin
    assert(XParticle.X = 1);
    assert(XParticle.Y = 1);
    assert(XParticle.Z = 1);
  end;
begin
  AParticle := TParticle3D.Create;
  BParticle := TParticle3D.Create;
  AVector.X := 1; AVector.Y := 1; AVector.Z := 1;
  AParticle.Velocity := AVector;
  BParticle.Velocity := AVector;
  FPSystem.AddParticle(AParticle);
  FPSystem.AddParticle(BParticle);
  FPSystem.Step(1);
  DoAsserts(AParticle);
  DoAsserts(BParticle);
end;

end.
