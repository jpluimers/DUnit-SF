{$APPTYPE CONSOLE}
program Project1TestSuite;

uses
  Forms,
  TestFramework,
  TestExtensions,
  CIXMLTestRunner,
  CIXMLReport,
  Project1TestCases in 'Project1TestCases.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DUnit Tests';

  CIXMLTestRunner.RunRegisteredTests('DunitCI','-Output.xml', rxbHaltOnFailures);
end.
