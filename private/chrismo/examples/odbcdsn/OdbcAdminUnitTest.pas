unit OdbcAdminUnitTest;

interface

uses SysUtils, OdbcAdminUnit, TestFramework;

type
  TOdbcAdminStub = class(TInterfacedObject, IOdbcAdmin)
  private
    FValidateDsnDriver: integer;
  protected
    CreateDsnRes: TOdbcAdminResult;
    CreateOrModifyDsnRes: TOdbcAdminResult;
    DeleteDsnRes: boolean;
    DsnExistsRes: boolean;
    GetDefaultDriverRes: string;
    ModifyDsnRes: TOdbcAdminResult;
    GetLastErrorRes: string;
    ValidateDsnDriverResA: boolean;
    ValidateDsnDriverResB: boolean;

    function GetValidateDsnDriverRes: boolean;
  public
    function CreateDsn(ADsn, ADriver, AServerName: string): TOdbcAdminResult;
      overload;
    function CreateDsn(ADsn, AServerName: string): TOdbcAdminResult; overload;
    function CreateOrModifyDsn(ADsn, ADriver, AServerName: string;
      AOdbcAction: TOdbcAdminAction): TOdbcAdminResult;
    function DeleteDsn(ADsn, ADriver: string): boolean; overload;
    function DeleteDsn(ADsn: string): boolean; overload;
    function DsnExists(ADsn: string): boolean;
    function GetDefaultDriver: string;
    function ModifyDsn(ADsn, ADriver, AServerName: string): TOdbcAdminResult;
      overload;
    function ModifyDsn(ADsn, AServerName: string): TOdbcAdminResult;
      overload;
    function GetLastError: string;
    function ValidateDsnDriver(ADsn, ADriver: string): boolean; overload;
    function ValidateDsnDriver(ADsn: string): boolean; overload;

    property DefaultDriver: string read GetDefaultDriver;
  end;

  const
  OdbcAdminStubCombos: array [0..63, 0..6] of boolean = (
//(DsnExists CreateDsn ValidateDsnA ModifyDsn DeleteDsn ValidateDsnB FINAL_RES),
  (true ,    true ,    true ,       true ,    true ,    true ,       true     ),//0
  (true ,    true ,    true ,       true ,    false,    true ,       true     ),
  (true ,    true ,    true ,       false,    true ,    true ,       false    ),
  (true ,    true ,    true ,       false,    false,    true ,       false    ),
  (true ,    true ,    false,       true ,    true ,    true ,       true     ),
  (true ,    true ,    false,       true ,    false,    true ,       false    ),
  (true ,    true ,    false,       false,    true ,    true ,       true     ),
  (true ,    true ,    false,       false,    false,    true ,       false    ),
  (true ,    false,    true ,       true ,    true ,    true ,       true     ),
  (true ,    false,    true ,       true ,    false,    true ,       true     ),
  (true ,    false,    true ,       false,    true ,    true ,       false    ),//10
  (true ,    false,    true ,       false,    false,    true ,       false    ),
  (true ,    false,    false,       true ,    true ,    true ,       false    ),
  (true ,    false,    false,       true ,    false,    true ,       false    ),
  (true ,    false,    false,       false,    true ,    true ,       false    ),
  (true ,    false,    false,       false,    false,    true ,       false    ),
  (true ,    true ,    true ,       true ,    true ,    false,       false    ),
  (true ,    true ,    true ,       true ,    false,    false,       false    ),
  (true ,    true ,    true ,       false,    true ,    false,       false    ),
  (true ,    true ,    true ,       false,    false,    false,       false    ),
  (true ,    true ,    false,       true ,    true ,    false,       false    ),//20
  (true ,    true ,    false,       true ,    false,    false,       false    ),
  (true ,    true ,    false,       false,    true ,    false,       false    ),
  (true ,    true ,    false,       false,    false,    false,       false    ),
  (true ,    false,    true ,       true ,    true ,    false,       false    ),
  (true ,    false,    true ,       true ,    false,    false,       false    ),
  (true ,    false,    true ,       false,    true ,    false,       false    ),
  (true ,    false,    true ,       false,    false,    false,       false    ),
  (true ,    false,    false,       true ,    true ,    false,       false    ),
  (true ,    false,    false,       true ,    false,    false,       false    ),
  (true ,    false,    false,       false,    true ,    false,       false    ),//30
  (true ,    false,    false,       false,    false,    false,       false    ),
  (false,    true ,    true ,       true ,    true ,    true ,       true     ),
  (false,    true ,    true ,       true ,    false,    true ,       true     ),
  (false,    true ,    true ,       false,    true ,    true ,       true     ),
  (false,    true ,    true ,       false,    false,    true ,       true     ),
  (false,    true ,    false,       true ,    true ,    true ,       false    ),
  (false,    true ,    false,       true ,    false,    true ,       false    ),
  (false,    true ,    false,       false,    true ,    true ,       false    ),
  (false,    true ,    false,       false,    false,    true ,       false    ),
  (false,    false,    true ,       true ,    true ,    true ,       false    ),//40
  (false,    false,    true ,       true ,    false,    true ,       false    ),
  (false,    false,    true ,       false,    true ,    true ,       false    ),
  (false,    false,    true ,       false,    false,    true ,       false    ),
  (false,    false,    false,       true ,    true ,    true ,       false    ),
  (false,    false,    false,       true ,    false,    true ,       false    ),
  (false,    false,    false,       false,    true ,    true ,       false    ),
  (false,    false,    false,       false,    false,    true ,       false    ),
  (false,    true ,    true ,       true ,    true ,    false,       true     ),
  (false,    true ,    true ,       true ,    false,    false,       true     ),
  (false,    true ,    true ,       false,    true ,    false,       true     ),//50
  (false,    true ,    true ,       false,    false,    false,       true     ),
  (false,    true ,    false,       true ,    true ,    false,       false    ),
  (false,    true ,    false,       true ,    false,    false,       false    ),
  (false,    true ,    false,       false,    true ,    false,       false    ),
  (false,    true ,    false,       false,    false,    false,       false    ),
  (false,    false,    true ,       true ,    true ,    false,       false    ),
  (false,    false,    true ,       true ,    false,    false,       false    ),
  (false,    false,    true ,       false,    true ,    false,       false    ),
  (false,    false,    true ,       false,    false,    false,       false    ),
  (false,    false,    false,       true ,    true ,    false,       false    ),//60
  (false,    false,    false,       true ,    false,    false,       false    ),
  (false,    false,    false,       false,    true ,    false,       false    ),
  (false,    false,    false,       false,    false,    false,       false    ));

type
  TTestDTOdbcAdmin = class(TTestCase)
  private
    FDsn: string;
    FOdbcAdminOrig: IOdbcAdmin;
    FOdbcAdminStub: TOdbcAdminStub;
    FCombination: integer;
    procedure SetCombination(const Value: integer);
  public
    procedure Setup; override;
    procedure TearDown; override;

    property Combination: integer read FCombination write SetCombination;
  published
    procedure testCombination;
  end;

  TTestDTOdbcAdminSuite = class(TTestSuite)
  protected
    procedure CreateComboTests;
  public
    constructor Create(Name: string); overload; override;
  end;

  function Suite: ITestSuite;

implementation

function Suite: ITestSuite;
begin
  Result := TTestDTOdbcAdminSuite.Create('DTOdbcAdmin Suite');
end;

{ TTestDTOdbcAdmin }

procedure TTestDTOdbcAdmin.SetCombination(const Value: integer);
begin
  FCombination := Value;
end;

procedure TTestDTOdbcAdmin.Setup;
begin
  inherited;
  FOdbcAdminStub := TOdbcAdminStub.Create;
  FOdbcAdminOrig := DTOdbcAdmin.FOdbcAdmin;
  DTOdbcAdmin.FOdbcAdmin := FOdbcAdminStub;
end;

procedure TTestDTOdbcAdmin.TearDown;
begin
  DTOdbcAdmin.FOdbcAdmin.DeleteDsn(FDsn);
  { remove stub, restore original, for any other test suites usage }
  DTOdbcAdmin.FOdbcAdmin := FOdbcAdminOrig;
  //FOdbcAdminStub.Free; //OdbcAdmin refers to it as interface, ref counts away
  inherited;
end;

procedure TTestDTOdbcAdmin.testCombination;
var
  ExpectedResult: boolean;

  function BooleanToTOdbcAdminResult(ABool: boolean): TOdbcAdminResult;
  begin
    if ABool then
      Result := orSuccess
    else
      Result := orUnknownError;
  end;
begin
  FOdbcAdminStub.DsnExistsRes          := OdbcAdminStubCombos[FCombination, 0];
  FOdbcAdminStub.CreateDsnRes          := BooleanToTOdbcAdminResult(OdbcAdminStubCombos[FCombination, 1]);
  FOdbcAdminStub.ValidateDsnDriverResA := OdbcAdminStubCombos[FCombination, 2];
  FOdbcAdminStub.ModifyDsnRes          := BooleanToTOdbcAdminResult(OdbcAdminStubCombos[FCombination, 3]);
  FOdbcAdminStub.DeleteDsnRes          := OdbcAdminStubCombos[FCombination, 4];
  FOdbcAdminStub.ValidateDsnDriverResB := OdbcAdminStubCombos[FCombination, 5];
  ExpectedResult                       := OdbcAdminStubCombos[FCombination, 6];

  System.assert(DTOdbcAdmin.CreateOdbcDsnIfNeeded = ExpectedResult);
end;

{ TTestDTOdbcAdminSuite }

constructor TTestDTOdbcAdminSuite.Create(Name: string);
begin
  inherited;
  CreateComboTests;
end;

procedure TTestDTOdbcAdminSuite.CreateComboTests;
var
  i: integer;
  ATestDTOdbcAdmin: TTestDTOdbcAdmin;
begin
  for i := 0 to 63 do
  begin
    ATestDTOdbcAdmin := TTestDTOdbcAdmin.Create('testCombination');
    ATestDTOdbcAdmin.fName := ATestDTOdbcAdmin.fName + IntToStr(i);
    ATestDTOdbcAdmin.Combination := i;
    AddTest(ATestDTOdbcAdmin);
  end;
end;

{ TOdbcAdminStub }

function TOdbcAdminStub.CreateDsn(ADsn,
  AServerName: string): TOdbcAdminResult;
begin
  Result := CreateDsnRes;
end;

function TOdbcAdminStub.CreateDsn(ADsn, ADriver,
  AServerName: string): TOdbcAdminResult;
begin
  Result := CreateDsnRes;
end;

function TOdbcAdminStub.CreateOrModifyDsn(ADsn, ADriver,
  AServerName: string; AOdbcAction: TOdbcAdminAction): TOdbcAdminResult;
begin
  Result := CreateOrModifyDsnRes;
end;

function TOdbcAdminStub.DeleteDsn(ADsn: string): boolean;
begin
  Result := DeleteDsnRes;
end;

function TOdbcAdminStub.DeleteDsn(ADsn, ADriver: string): boolean;
begin
  Result := DeleteDsnRes;
end;

function TOdbcAdminStub.DsnExists(ADsn: string): boolean;
begin
  Result := DsnExistsRes;
end;

function TOdbcAdminStub.GetDefaultDriver: string;
begin
  Result := GetDefaultDriverRes;
end;

function TOdbcAdminStub.GetLastError: string;
begin
  Result := GetLastErrorRes;
end;

function TOdbcAdminStub.GetValidateDsnDriverRes: boolean;
begin
  if (FValidateDsnDriver mod 2) = 0 then
    Result := ValidateDsnDriverResA
  else
    Result := ValidateDsnDriverResB;

  Inc(FValidateDsnDriver);
end;

function TOdbcAdminStub.ModifyDsn(ADsn,
  AServerName: string): TOdbcAdminResult;
begin
  Result := ModifyDsnRes;
end;

function TOdbcAdminStub.ModifyDsn(ADsn, ADriver,
  AServerName: string): TOdbcAdminResult;
begin
  Result := ModifyDsnRes;
end;

function TOdbcAdminStub.ValidateDsnDriver(ADsn: string): boolean;
begin
  Result := GetValidateDsnDriverRes;
end;

function TOdbcAdminStub.ValidateDsnDriver(ADsn, ADriver: string): boolean;
begin
  Result := GetValidateDsnDriverRes;
end;

end.
