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

end.
