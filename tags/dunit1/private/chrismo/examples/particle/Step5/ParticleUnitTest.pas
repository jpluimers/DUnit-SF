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
