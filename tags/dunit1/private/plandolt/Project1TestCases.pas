unit Project1TestCases;

interface

uses
  TestFrameWork;

type
  TTestCaseSuiteBase = class(TTestCase)
  published
    procedure TestFirst;
    procedure TestSecond;
    procedure TestThird;
  end;

  TTestCaseSuiteTwo = class(TTestCase)
  published
    procedure TestFourth;
  end;


implementation

procedure TTestCaseSuiteBase.TestFirst;
begin
 Check(1 + 1 = 2, 'Catastrophic arithmetic failure!');
end;


procedure TTestCaseSuiteBase.TestSecond;

begin
  Check(true, 'Holder');

  Check(1 + 1 = 3, 'Deliberate failure');
end;

procedure TTestCaseSuiteBase.TestThird;
var
  i: Integer;

begin
  i := 0;

  Check(1 div i = i, 'Deliberate exception');
end;


procedure TTestCaseSuiteTwo.TestFourth;
begin
  Check(true, 'Holder');
end;

initialization
  TestFramework.RegisterTest(TTestCaseSuiteBase.Suite);
  TestFramework.RegisterTest(TTestCaseSuiteTwo.Suite);
end.


