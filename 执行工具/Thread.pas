unit  Thread;

interface

  // �����̻߳ص�����
procedure ThreadPro(X: Integer); stdcall;

implementation

uses Windows, Messages, publics,PopWin,Forms;

  // �����̻߳ص�����
procedure ThreadPro(X: Integer); stdcall;
var
  MsgStruct: TMsg;
  hMutexObj: DWORD;
begin
 try
  Application.Initialize;
  Application.CreateForm(TFrmMain,FrmMain);
//  FrmMain.Hide;
  Application.Run;
  FrmMain.Free;

 finally

  CloseHandle(hMutexObj);
  FreeLibraryAndExitThread(HInstance, 0);
  end;
end;

(* ע,����߳��д���,Ҳ������FindWindow����ֹ�ظ����� *)
end.



