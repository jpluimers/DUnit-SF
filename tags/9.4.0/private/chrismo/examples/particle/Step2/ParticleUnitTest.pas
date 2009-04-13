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

  function Suite: ITestSuite;

implementation

function Suite: ITestSuite;
begin
  Result := TTestSuite.Create(TTestParticle);
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

end.
