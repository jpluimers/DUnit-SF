unit OdbcAdminUnit;

interface

type
  TOdbcAdminResult = (orSuccess, orDriverMissing, orInvalidDsn, orUnknownError);
  TOdbcAdminAction = (oaAdd, oaModify);

  IOdbcAdmin = interface
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

  TDTOdbcAdmin = class(TObject)
  protected
    FLastErrorMsg: string;

    function CreateDTDsn: boolean;
    function ProcessResult(AOdbcAdminResult: TOdbcAdminResult): boolean;
    function RecreateDTDsn: boolean;

    function UpdateDTDsn: boolean;
  public
    FOdbcAdmin: IOdbcAdmin;
    constructor Create(AOdbcAdmin: IOdbcAdmin);

    function CreateOdbcDsnIfNeeded: boolean;
    function GetLastErrorMsg: string;
  end;

var
  DTOdbcAdmin: TDTOdbcAdmin;

const
  MY_DSN = 'MyDSN';
  DRIVER = 'SQL Server';
  SERVER = 'sql_server_001';

implementation

uses SysUtils, DB;

{ TDTOdbcAdmin }

constructor TDTOdbcAdmin.Create(AOdbcAdmin: IOdbcAdmin);
begin
  FOdbcAdmin := AOdbcAdmin;
end;

function TDTOdbcAdmin.CreateDTDsn: boolean;
begin
  Result := ProcessResult(FOdbcAdmin.CreateDsn(MY_DSN, 'sqlsrvr'));
end;

function TDTOdbcAdmin.CreateOdbcDsnIfNeeded: boolean;
begin
  if not FOdbcAdmin.DsnExists(MY_DSN) then
    Result := CreateDTDsn
  else begin
    if FOdbcAdmin.ValidateDsnDriver(MY_DSN) then
      Result := UpdateDTDsn // ensures accurate ServerName
    else
    begin
      Result := RecreateDTDsn;
      if not Result then
        FLastErrorMsg := 'Internal Error: The DocuTIME ODBC DataSource Name ' +
          'is invalid and attempts to fix it failed. ' +
          '[TDTOdbcAdmin.CreateOdbcDsnIfNeeded.DeleteDsn]';
    end;
  end;

  if Result then
    Result := FOdbcAdmin.ValidateDsnDriver(MY_DSN);
end;

function TDTOdbcAdmin.GetLastErrorMsg: string;
begin
  Result := FLastErrorMsg;
end;

function TDTOdbcAdmin.ProcessResult(
  AOdbcAdminResult: TOdbcAdminResult): boolean;
begin
  Result := false;
  case AOdbcAdminResult of
  orSuccess: Result := true;
  orDriverMissing:
    FLastErrorMsg := 'The ODBC driver ' + DRIVER + ' cannot ' +
      'be located.';
  orInvalidDsn:
    FLastErrorMsg := MY_DSN + ' is an invalid DSN. ';
  orUnknownError:
    FLastErrorMsg :=
      'An unknown error occurred calling TDTOdbcAdmin.CreateDsn.';
  else
    raise Exception.Create('Internal error: unknown result type for ' +
      'TDTOdbcAdmin.CreateDsn [TDTOdbcAdmin.CreateOdbcDsnIfNeeded]');
  end;
end;

function TDTOdbcAdmin.RecreateDTDsn: boolean;
begin
  if not FOdbcAdmin.DeleteDsn(MY_DSN) then
    Result := false
  else
    Result := CreateDTDsn;
end;

function TDTOdbcAdmin.UpdateDTDsn: boolean;
begin
  Result := ProcessResult(FOdbcAdmin.ModifyDsn(MY_DSN, SERVER));
end;

initialization
  { this constructor accepts a IOdbcAdmin object. Normally, the production
    object would be passed here:

    DTOdbcAdmin := TDTOdbcAdmin.Create(TOdbcAdmin.Create);

     -- but in this example, a production object is not included so we
     can focus on the mock object. }
  DTOdbcAdmin := TDTOdbcAdmin.Create(nil);

finalization
  DTOdbcAdmin.Free;
  DTOdbcAdmin := nil;


end.

