program ParticleTest;

uses
  GUITestRunner,
  TestFramework,
  ParticleUnitTest;

{$R *.RES}

function MasterTestSuite: ITestSuite;
begin
  Result := TTestSuite.Create('Particle Test');
  Result.AddTest(ParticleUnitTest.Suite);
end;

begin
  GUITestRunner.RunTest(MasterTestSuite);
end.
