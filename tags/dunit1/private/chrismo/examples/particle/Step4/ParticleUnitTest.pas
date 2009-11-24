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
    procedure TestParticleSystem;
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

procedure TTestParticleSystem.TestParticleSystem;
var
  AParticle: TParticle3D;
begin
  assert(FPSystem.ParticleCount = 0);
  assert(FPSystem.Particles[0] = nil);
  FPSystem.AddRandomParticle;
  assert(FPSystem.ParticleCount = 1);
  assert(FPSystem.Particles[0] <> nil);
end;

end.
