unit unitFrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ToolWin, ImgList, WinSkinData;

type
  TForm_record = class(TForm)
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    Button1: TToolButton;
    Button3: TToolButton;
    Button2: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    Label1: TLabel;
    ToolButton4: TToolButton;
    Label_count: TLabel;
    Label3: TLabel;
    SaveDialog1: TSaveDialog;
    SkinData1: TSkinData;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RC_count(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  Form_record: TForm_record;
  hHook, hPlay: Integer;
  recOK: Integer;
  canPlay: Integer;
  bDelay: Bool;

  lastpos:TPoint;
  lasttime:DWORD;
  RScr:TStringList;
implementation

{$R *.DFM}

procedure Waitmanage(tt:DWORD);
begin
if tt -lasttime >500 then
begin
RScr.Add(Format('�ȴ�(%d)����',[(tt-lasttime)]));
end;
lasttime:=tt;
end;

//HookProc�Ǽ�¼��������Ϣ������ÿ������������Ϣ����ʱ��ϵͳ������øú�������Ϣ��
//Ϣ�ͱ����ڵ�ַlParam�У����ǿ��԰���Ϣ������һ�������С�

function HookProc(iCode: Integer; wParam: wParam; lParam: lParam): LRESULT; stdcall;
var
  myEVENTMSG:EVENTMSG;
begin
  recOK := 1;
  Result := 0;
  if iCode < 0 then
    Result := CallNextHookEx(hHook, iCode, wParam, lParam)
  else if iCode = HC_SYSMODALON then
    recOK := 0
  else if iCode = HC_SYSMODALOFF then
    recOK := 1
  else if ((recOK > 0) and (iCode = HC_ACTION)) then begin
    myEVENTMSG:=PEventMsg(lParam)^;
    case myEVENTMSG.message of

  //       WM_MOUSEMOVE  : RScr.Add(Format('WM_MOUSEMOVE:  %d,%d',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
 //        WM_KEYDOWN  :   RScr.Add(Format('WM_KEYDOWN:  %s  ,%d',[  Keyhookresult(myEVENTMSG.paramL,myEVENTMSG.paramH)]));

        WM_KEYDOWN        :
               begin
               Waitmanage(myEVENTMSG.time);
               RScr.Add(Format('����(%d,1)',[lobyte( myEVENTMSG.paramL)]));
               end;
        WM_KEYUP          :
               begin
                Waitmanage(myEVENTMSG.time);
               RScr.Add(Format('�ſ�(%d,1)',[lobyte( myEVENTMSG.paramL)]));
               //  WM_KEYDOWN        :RScr.Add(Format('����(%d,1)',[lobyte(myEVENTMSG.paramL)]));
               end ;
         WM_SYSKEYDOWN:
           begin
              Waitmanage(myEVENTMSG.time);
             RScr.Add(Format('����(%d,1)',[lobyte( myEVENTMSG.paramL)]));  //ALT
            end;
         WM_SYSKEYUP:
            begin
              Waitmanage(myEVENTMSG.time);
             RScr.Add(Format('�ſ�(%d,1)',[lobyte( myEVENTMSG.paramL)]));  //ALT
             end;
         WM_LBUTTONDBLCLK  :
           begin
               Waitmanage(myEVENTMSG.time);
               lastpos.X:= myEVENTMSG.paramL;
               lastpos.Y:= myEVENTMSG.paramH ;
               RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
               RScr.Add('���˫��(1)��');
            end;
           WM_LBUTTONDOWN  :
           begin
               Waitmanage(myEVENTMSG.time);
                   if   (lastpos.X<>myEVENTMSG.paramL)  or (lastpos.Y<>myEVENTMSG.paramH) then
                       begin
                          RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
                           lastpos.X:= myEVENTMSG.paramL;
                           lastpos.Y:= myEVENTMSG.paramH ;
                        end ;
                 RScr.Add('�������(1)��');
            end;

         WM_LBUTTONUP  :
           begin
             if   (lastpos.X= myEVENTMSG.paramL)  and (lastpos.Y= myEVENTMSG.paramH) then
             begin
                     RScr.Strings[RScr.Count-1]:='�������(1)��';
               end
                else
                    begin
                      Waitmanage(myEVENTMSG.time);
                      RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
                      RScr.Add('����ſ�(1)��');
                  end;
            end;

          WM_RBUTTONDOWN  :
           begin
               Waitmanage(myEVENTMSG.time);
                   if   (lastpos.X<>myEVENTMSG.paramL)  or (lastpos.Y<>myEVENTMSG.paramH) then
                       begin
                          RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
                           lastpos.X:= myEVENTMSG.paramL;
                           lastpos.Y:= myEVENTMSG.paramH ;
                        end ;
               RScr.Add('�Ҽ�����(1)��');
            end;

         WM_RBUTTONUP  :
             begin
             if   (lastpos.X= myEVENTMSG.paramL)  and (lastpos.Y= myEVENTMSG.paramH) then
             begin
                     RScr.Strings[RScr.Count-1]:='�Ҽ�����(1)��';
               end
                else
                    begin
                      Waitmanage(myEVENTMSG.time);
                      RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
                      RScr.Add('�Ҽ��ſ�(1)��');
                  end;
            end;
         WM_RBUTTONDBLCLK:
           begin
              Waitmanage(myEVENTMSG.time);
               RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
               RScr.Add('�Ҽ�˫��(1)��');
            end;
         WM_MBUTTONDOWN:
             begin
                   Waitmanage(myEVENTMSG.time);
                   if   (lastpos.X<>myEVENTMSG.paramL)  or (lastpos.Y<>myEVENTMSG.paramH) then
                       begin
                          RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
                           lastpos.X:= myEVENTMSG.paramL;
                           lastpos.Y:= myEVENTMSG.paramH ;
                        end  ;
               RScr.Add('�м�����(1)��');
            end;
         WM_MBUTTONUP:
           begin
              Waitmanage(myEVENTMSG.time);
             if   (lastpos.X= myEVENTMSG.paramL)  and (lastpos.Y= myEVENTMSG.paramH) then
             begin
                     RScr.Strings[RScr.Count-1]:='�м�����(1)��';
               end
                else
                    begin
                      Waitmanage(myEVENTMSG.time);
                      RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
                      RScr.Add('�м��ſ�(1)��');
                  end;
            end;

        end;

    end;
  end;

//�����¼��ť��ʼ¼�����

procedure TForm_record.Button1Click(Sender: TObject);
begin
     RScr.Clear;
     RScr.Add('[General]');
     RScr.Add('[Comment]');
     RScr.Add('[Script]');
     SaveDialog1.InitialDir:=ExtractFilePath(Application.ExeName)+'script\';
     SaveDialog1.Title:='����¼�ƵĽű�';

  hHook := SetwindowsHookEx(WH_JOURNALRECORD, HookProc, HInstance, 0);
  lasttime:=GetTickCount;
  Button2.Enabled := True;
  Button1.Enabled := False;
end;

procedure TForm_record.Button2Click(Sender: TObject);
begin
  UnHookWindowsHookEx(hHook);
  hHook := 0;
  Button1.Enabled := True;
  Button2.Enabled := False;
end;

function  GetKeyName(wVirtualKey:WORD):string;
var
 szKeyName:array[0..255] of Char;
 nScanCode:Integer;
 begin
 FillChar(szKeyName,255,#0);
 nScanCode:=   MapVirtualKey(wVirtualKey,   0)   shl   16;
          if(nScanCode   <>   0) then
          begin
                  GetKeyNameText(nScanCode,   szKeyName,   255);
                  Result:=StrPas(@szKeyName[0]) ;
            end
          else
        Result:= '';
end;

procedure TForm_record.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if  hHook<>0 then
begin
  UnHookWindowsHookEx(hHook);
  hHook := 0;
  Button1.Enabled := True;
  Button2.Enabled := False;
end;
RScr.Free;
end;

procedure TForm_record.RC_count(Sender: TObject);
begin
Form_record.Label_count.Caption:=IntToStr(RScr.Count);
end;

procedure TForm_record.FormCreate(Sender: TObject);
begin
RScr:=TStringList.Create;
RScr.OnChange:=Form_record.RC_count ;

end;

procedure TForm_record.Button3Click(Sender: TObject);
begin
if SaveDialog1.Execute then
begin
     RScr.Delete(RScr.Count-1);
     RScr.Delete(RScr.Count-1);
     RScr.Delete(RScr.Count-1);
     RScr.SaveToFile(SaveDialog1.FileName);
  end;
end;

end.

