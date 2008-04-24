program OdbcAdminTest;

uses
  TestFramework,
  GUITestRunner,
  OdbcAdminUnitTest;

{$R *.RES}

function MasterTestSuite: ITestSuite;
begin
  Result := TTestSuite.Create('Odbc Admin Example');
  Result.addTest(OdbcAdminUnitTest.Suite);
end;

begin
  GUITestRunner.RunTest(MasterTestSuite);
end.
