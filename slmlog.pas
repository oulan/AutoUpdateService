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
  EnterCriticalSection(cs);  //关键代码段
  try try
    AssignFile(F, ALogFile);
    if FileExists(ALogFile) then Append(F) else ReWrite(F);
    case AFlag of
      1: begin
        WriteLn(F, ''); //换行
        Write(F, Format('%s %-16s %s', [FormatDateTime('yyyy-MM-dd hh:mm:ss.zzz', now), ChangeFileExt(ExtractFileName(GetModuleName(hInstance)), ''), ALog])); //一行的开始
      end;
      2: Write(F, Format(' %s', [ALog])); //一行的中间内容
      3: WriteLn(F, Format(' %s', [ALog])); //一行的结束
      else
        WriteLn(F, Format('%s %-16s %s', [FormatDateTime('yyyy-MM-dd hh:mm:ss.zzz', now), //单独一行
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
