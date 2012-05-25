unit uUpdateService;

interface

implementation

uses JwaWinSvc, uGlobal;

procedure UpdateService(AOldFile, ANewFile, AServiceName: string);
var
  F  : TextFile;
  hSCManager: THandle;
  hService: THandle;
  qsc: TQueryServiceConfig;
  BytesNeeded: Cardinal;
  AppExeName: string;
begin
  //��ȡ��������Ϣ
  hSCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if hSCManager = 0 then exit;
  hService := OpenService(hSCManager, PChar(AServiceName), SERVICE_ALL_ACCESS);
  if hService = 0 then exit;
  if not QueryServiceConfig(hService, @qsc, sizeof(qsc), BytesNeeded) then exit;
  AppExeName := qsc.lpBinaryPathName;
  
  //׼���������ļ�
  AssignFile(F, ExtractFilePath(AppExeName) + 'UpdateAndRestartService.bat');
  ReWrite(F);
  WriteLn(F, 'net stop ' + ThisServiceDisplayName);
  WriteLn(F, 'del ' + AppExeName);
  WriteLn(F, 'ren ' + ANewFileName + ' ' + ExtractFileName(AppExeName));
  WriteLn(F, 'net start ' + ThisServiceDisplayName);
  CloseFile(F);

  //ִ���������ļ�
  WinExec(PChar(ExtractFilePath(AppExeName) + 'UpdateAndRestartService.bat'), SW_HIDE);
end;

end.
