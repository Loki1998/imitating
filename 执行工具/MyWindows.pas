{


  my_u32:string    ='Hook2.dll';
  my_kernel:string ='Hook1.dll';
  my_gdi32:string ='Hook3.dll';
  MI_WINIO:string  ='WinIo.dll';


}

unit MyWindows;

interface
  uses windows, SysUtils,Registry,Messages,Dialogs;

procedure LoadMYFUN ;
procedure MYinput(nr:string);
procedure KeyPressH(VCode: byte);
procedure KeyDownH(VCode: byte);
procedure KeyUPH(VCode: byte);
procedure SetKey(SCanCode: byte);
procedure SendKeys(sSend:string);

var

//==========================_winio======================================
InitializeWinIo: function :Boolean;stdcall;
GetPortVal: function (PortAddr:integer;PortVal:PDWORD;bSize:BYTE):Boolean;stdcall;
SetPortVal: function (PortAddr:integer;PortVal:DWORD;bSize:BYTE):Boolean;stdcall;
ShutdownWinIo:function :Boolean;stdcall;

implementation
uses
   Run_script;

function ReadDir: string;
var
REG:TRegistry;
keyname:string;
begin
REG:=TRegistry.Create;
keyname:='path';
try
    reg.rootkey:=HKEY_LOCAL_MACHINE;
    reg.OpenKey('Software\ģ��֮��',True);
    result:=reg.readstring(keyname);
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;


procedure LoadMYFUN;
var
GetDir:string;
p:Pointer;
begin

GetDir:=ReadDir();
//==========================_WinIO======================================
if not restrict then
begin
MI_WINIO:=GetDir+MI_WINIO;
_WINIO:=LoadLibrary(pchar(MI_WINIO));
InitializeWinIo:= GetProcAddress(_WINIO, 'InitializeWinIo');
GetPortVal:= GetProcAddress(_WINIO, 'GetPortVal');
SetPortVal:= GetProcAddress(_WINIO, 'SetPortVal');
ShutdownWinIo:= GetProcAddress(_WINIO, 'ShutdownWinIo');

InitializeWinIo;   //����WINIO.SYS
end;
end;




procedure MYinput(nr:string);
var
  f1,f2,f3,i:longint;
begin
    f1:=GetForegroundWindow;
    f2:=GetWindowThreadProcessId(f1,nil);
    AttachThreadInput(GetCurrentThreadId,f2,true);
    f3:=getfocus;
    AttachThreadInput(GetCurrentThreadId,f3,false);
    i:=1;
        while i <= Length(nr) do
        begin
        if Ord(nr[i])>127 then
        begin
        SendMessage(f3,$0286,(ord(nr[i]) shl 8) + ord(nr[i+1]) , 0);
        inc(i,2);
        end
        else
        begin
          SendMessage(f3,$0286,ord(nr[i]) , 0);
        inc(i,1);
          end;
       end;
   end;



procedure SendKeys(sSend:string);
var
    i:integer;
    Sstr:string;
    focushld,windowhld:hwnd;
    threadld:dword;
    ch: byte;
begin
  windowhld:=GetForegroundWindow;
  threadld:=GetWindowThreadProcessId(Windowhld,nil);
  AttachThreadInput(GetCurrentThreadId,threadld,true);
  Focushld:=getfocus;
  AttachThreadInput(GetCurrentThreadId,threadld,false);
  if focushld = 0 then Exit;
  i := 1;
  while i <= Length(sSend) do
  begin
    ch := byte(sSend[i]);
    if Windows.IsDBCSLeadByte(ch) then
    begin
      Inc(i);
      SendMessage(focushld, WM_IME_CHAR, MakeWord(byte(sSend[i]), ch), 0);
    end
    else
      SendMessage(focushld, WM_IME_CHAR, word(ch), 0);
    Inc(i);
  end;
end;



procedure SetKey(SCanCode: byte);
begin
  asm
    //������0x60,����0x64д����ǰ��Ҫ��״̬�Ĵ���OBF��0
    @Loop1:
    in al, $64
    and al, 10b
    jnz @Loop1
    //��$64�˿�д����
    mov al, $D2//д���������������    0xD2��д���̻���������0xD3��д��껺������
    out $64, al

    //������0x60,����0x64д����ǰ��Ҫ��״̬�Ĵ���OBF��0
    @Loop2:
    in al, $64
    and al, 10b
    jnz @Loop2
    //��$60�˿�д����
    mov al, SCanCode
    out $60, al
  end;
end;

procedure KeyPressH(VCode: byte);
begin
SetKey(MapVirtualKey(Ord(VCode), 0));
Sleep(25);
SetKey(MapVirtualKey(Ord(VCode), 0) +$80);
end;

procedure KeyDownH(VCode: byte);
begin
SetKey(MapVirtualKey(ord(VCode), 0));
Sleep(10);
end;

procedure KeyUPH(VCode: byte);
begin
SetKey(MapVirtualKey(ord(VCode), 0) +$80);
Sleep(10) ;
end;

end.

