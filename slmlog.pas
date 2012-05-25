unit slmlog;

interface

function SaveToLogFile(const ALogFile, ALog : string; AFlag: byte = 0): boolean;

implementation

uses SysUtils, Windows;

var
  cs : TRTLCriticalSection;

function SaveToLogFile(const ALogFile, ALog : string; AFlag: byte = 0): boolean;
var
  F  : TextFile;
begin
  result := false;
  EnterCriticalSection(cs);  //�ؼ������
  try try
    AssignFile(F, ALogFile);
    if FileExists(ALogFile) then Append(F) else ReWrite(F);
    case AFlag of
      1: begin
        WriteLn(F, ''); //����
        Write(F, Format('%s %s', [FormatDateTime('yyyy-MM-dd hh:mm:ss', now), ALog])); //һ�еĿ�ʼ
      end;
      2: Write(F, Format(' %s', [ALog])); //һ�е��м�����
      3: WriteLn(F, Format(' %s', [ALog])); //һ�еĽ���
      else
        WriteLn(F, Format('%s %-16s %s', [FormatDateTime('yyyy-MM-dd hh:mm:ss.zzz', now), //����һ��
                                          ChangeFileExt(ExtractFileName(GetModuleName(hInstance)), ''),
                                          ALog]));
    end;
    CloseFile(F);
    result := true;
  except

  end;
  finally
    LeaveCriticalSection(cs);
  end;
end;

initialization
  InitializeCriticalSection(cs);

end.