library  Insert;

 // ����ͼ��

uses
  Windows,
  Messages,
  SysUtils,
  Registry,
  JumpHook in 'JumpHook.pas',
  Thread in 'Thread.pas',
  publics in 'publics.pas',
  PopWin in 'PopWin.pas' {FrmMain},
  Run_script in 'Run_script.pas';

exports
  JumpHookOn, JumpHookOff;

const
  sFileMap = 'sFileMap_LiuMazi'; // �ڴ�ӳ���ļ�
  sProcess = 'Audition.exe';     // ������̶���


var
  PMainThreadID: PDWORD;
  Dll_kernel: THandle;
  Dll_my_kernel:string;
  MutexHandle, FileHandle, SubThreadID: DWORD;
  ModuleFileName: array [0..MAX_PATH] of Char;
  MYGetModuleFileName : function (hModule: HINST; lpFilename: PChar; nSize: DWORD): DWORD; stdcall;


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

begin
  Dll_my_kernel:= ReadDir+my_kernel;
  Dll_kernel:=LoadLibrary(pchar(Dll_my_kernel));
  MYGetModuleFileName:=GetProcAddress(Dll_kernel,'GetModuleFileNam_A'); //ȡ��API��ַ

 // ���DLL����Ľ���
  MYGetModuleFileName(0, @ModuleFileName[0], MAX_PATH);
  if CompareAnsiText(ExtractFileName(ModuleFileName), sProcess) then
  begin
   // ��ֻ֤��һ���߳�
    MutexHandle := OpenMutex(MUTEX_ALL_ACCESS, FALSE, DllMutex);
    if (MutexHandle <> 0) then
    begin
      CloseHandle(MutexHandle)
    end  
    else begin
     // ��sProcess���߳�
      CreateThread(nil, 0, @ThreadPro, nil, 0, SubThreadID);
     // �����������ü���
      GetModuleFileName(HInstance, @ModuleFileName[0], MAX_PATH);
      LoadLibrary(@ModuleFileName[0]);
     // ֪ͨStart.exe�˳�
      FileHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, sFileMap);
      PMainThreadID := MapViewOfFile(FileHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
      PostThreadMessage(PMainThreadID^, WM_QUIT, 0, 0);
      UnmapViewOfFile(PMainThreadID);
      CloseHandle(FileHandle);                        
    end;
  end;  
end.

