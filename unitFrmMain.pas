unit unitFrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ToolWin, ImgList, WinSkinData,CoolTrayIcon;

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
    procedure beginRecord;
    procedure StopRecord;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RC_count(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure   CreateParams(var   Params:   TCreateParams);override;
    procedure Showme;


  private
    { Private declarations }
  public

    { Public declarations }
  end;
type
    TKeyStat=(t_Nothing,t_KeyUp,t_KeyDown,t_MouseUp,t_MouseDown);

var
  Form_record: TForm_record;
  hHook, hPlay: Integer;
  recOK: Integer;
  canPlay: Integer;
  bDelay: Bool;
  recded:Boolean=False;
  lastpos:TPoint;
  lasttime:DWORD;
  RScr:TStringList;
  LASTKEYDOWN,lastsyskey:LongWord;
  RecordIng:Boolean=False;  //��¼��
  MousePath:Boolean=True;
  Mouse_Down:boolean=False;
  KeyStat:TKeyStat=t_Nothing;
implementation

uses Cladmin;

{$R *.DFM}
procedure   TForm_record.CreateParams(var   Params:   TCreateParams);
  begin  
      inherited;  
      Params.WndParent:=GetDesktopWindow;  
      Params.EXStyle:=Params.ExStyle   or   WS_EX_TOOLWINDOW;  
  end;

procedure Waitmanage(tt:DWORD);
begin
if tt -lasttime >100 then
begin
RScr.Add(Format('�ȴ�(%d)����',[(tt-lasttime)]));
end;
lasttime:=tt;
end;

procedure Waitmanage10(tt:DWORD);
begin
if tt -lasttime >10 then
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

  if not RecordIng then
   begin
         myEVENTMSG:=PEventMsg(lParam)^;
         case myEVENTMSG.message of
          WM_KEYDOWN  :
               begin
                    if (lobyte(myEVENTMSG.paramL)=145) then      //���� Scroll ʱ ��ʼ
                      begin
                         Form_record.beginRecord;
                       end;
               end;
            end;   
      end
    else
    begin
     //������Լ��Ͳ���������
    if GetActiveWindow() = Form_record.Handle then Exit;
    myEVENTMSG:=PEventMsg(lParam)^;
    case myEVENTMSG.message of
            WM_MOUSEMOVE  :       //����ƶ�
               begin
                 if not MousePath then Exit;
                 if (lastpos.X=myEVENTMSG.paramL) and  (lastpos.Y= myEVENTMSG.paramH) then exit;
                 lastpos.X:= myEVENTMSG.paramL;
                 lastpos.Y:= myEVENTMSG.paramH ;
                  Waitmanage10(myEVENTMSG.time);
                  RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
                end;
        WM_KEYDOWN        :
               begin
               KeyStat:=t_KeyDown;
               if (lobyte(myEVENTMSG.paramL)=145) then
                begin
                Form_record.StopRecord ;
                Exit;
                end;
               Waitmanage(myEVENTMSG.time);
               if LASTKEYDOWN = myEVENTMSG.paramL then Exit;
               RScr.Add(Format('����(%d,1)',[lobyte( myEVENTMSG.paramL)]));
               LASTKEYDOWN:=myEVENTMSG.paramL;
               end;
        WM_KEYUP          :
               begin
                Waitmanage(myEVENTMSG.time);
                if myEVENTMSG.paramL=0 then Exit;

                      if KeyStat=t_keyup then Exit;
                      RScr.Add(Format('�ſ�(%d,1)',[lobyte( myEVENTMSG.paramL)]));
                      KeyStat:=t_KeyUp;
               //  WM_KEYDOWN        :RScr.Add(Format('����(%d,1)',[lobyte(myEVENTMSG.paramL)]));
               end ;
         WM_SYSKEYDOWN:
           begin
            if   lastsyskey<>myEVENTMSG.paramL then
             begin
              Waitmanage(myEVENTMSG.time);
              RScr.Add(Format('����(%d,1)',[lobyte( myEVENTMSG.paramL)]));  //ALT
              lastsyskey:=myEVENTMSG.paramL;
              end;
            end;
         WM_SYSKEYUP:
            begin
              if myEVENTMSG.paramL =0 then Exit;
              Waitmanage(myEVENTMSG.time);
              RScr.Add(Format('�ſ�(%d,1)',[lobyte( myEVENTMSG.paramL)]));  //ALT
              lastsyskey:=0;
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
               if  Mouse_Down then Exit;
                   if   (lastpos.X<>myEVENTMSG.paramL)  or (lastpos.Y<>myEVENTMSG.paramH) then
                       begin
                          RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
                           lastpos.X:= myEVENTMSG.paramL;
                           lastpos.Y:= myEVENTMSG.paramH ;
                        end ;
                 Mouse_Down:=True;
                 RScr.Add('�������(1)��');
            end;

         WM_LBUTTONUP  :
           begin
             Mouse_Down:=False;
             if   (abs(lastpos.X- myEVENTMSG.paramL)<10)  and (abs(lastpos.Y - myEVENTMSG.paramH)<10) then
             begin
                    if MousePath then
                    begin
                     RScr.Delete(RScr.Count-1);
                     RScr.Strings[RScr.Count-1]:='�������(1)��';
                     end
                    else
                    begin
                      RScr.Strings[RScr.Count-1]:='�������(1)��';
                      end;
               end
                else
                    begin
                      Waitmanage(myEVENTMSG.time);
                      RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
                      RScr.Add('����ſ�(1)��');
                  end;
            end;

         WM_RBUTTONUP  :
             begin
              RScr.Add(Format('����Ƶ�(%d,%d)',[myEVENTMSG.paramL,myEVENTMSG.paramH]));
              Waitmanage(myEVENTMSG.time);
              RScr.Strings[RScr.Count-1]:='�Ҽ�����(1)��';
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
       end;    // startrecord
    end;
  end;


procedure TForm_record.Showme;
begin
  MousePath:=  Setup.ReadBool('ϵͳ����','¼�����·��',True);
 Form_Admin.CoolTrayIcon1.ShowBalloonHint('��ʾ','�����԰� ScrollLock�� ���������ɫ��ť����ʼ¼��,'
     +#13#10+'�ٴΰ��� ScrollLock�� �� ��ɫ ��ť��ֹͣ¼��', bitInfo, 10);
 Form_record.Show;
 hHook := SetwindowsHookEx(WH_JOURNALRECORD, HookProc, HInstance, 0);

end;

//�����¼��ť��ʼ¼�����

procedure TForm_record.beginRecord  ;
begin
  RecordIng:=True;
  lasttime:=GetTickCount;
     recded:=True;
     RScr.Clear;
     RScr.Add('[General]');
     RScr.Add('[Comment]');
     RScr.Add('[Script]');
     SaveDialog1.InitialDir:=ExtractFilePath(Application.ExeName)+'script\';
     SaveDialog1.Title:='����¼�ƵĽű�';
  Button2.Enabled := True;
  Button1.Enabled := False;
end;


procedure TForm_record.StopRecord;
begin
   RecordIng:=False;
   Button1.Enabled := True;
   Button3.Enabled := True;
   Button2.Enabled := False;
  end;

procedure TForm_record.Button1Click(Sender: TObject);
begin
  beginRecord;
end;

procedure TForm_record.Button2Click(Sender: TObject);
begin
  StopRecord;
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
  Button3.Enabled:=False;
end;

if recded then
 begin
   case Application.MessageBox('��¼����һ���ű�,Ҫ��������?', 
     '��ʾ', MB_YESNOCANCEL + MB_ICONQUESTION + MB_TOPMOST) of
     IDCANCEL:
       begin
         Action:=caNone;
       end;
     IDYES:              //����ű�
       begin
          Action:=caNone;
              if SaveDialog1.Execute then
                begin
                     RScr.Delete(RScr.Count-1);
                     RScr.Delete(RScr.Count-1);
                     RScr.Delete(RScr.Count-1);
                     RScr.SaveToFile(SaveDialog1.FileName);
                     Button3.Enabled := False;
                     recded:=False;
                  end;
          Form_record.Hide;
          Form_Admin.show;
          Form_Admin.FlashScript;
       end;
     IDNO:
       begin
         Action:=caNone;
         Form_record.Hide;
         Form_Admin.show;
         Form_Admin.FlashScript;
       end;
    end;     //end case
  Exit;
end;  //end if

 //==�ű�û�б��޸�,ֱ���˳�===
 Action:=caNone;
 Form_record.Hide;
 Form_Admin.show;
 Form_Admin.FlashScript;
end;

procedure TForm_record.RC_count(Sender: TObject);
begin
Form_record.Label_count.Caption:=IntToStr(RScr.Count-3);
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
     RScr.SaveToFile(SaveDialog1.FileName);
     Button3.Enabled := False;
     recded:=False;
  end;
end;

procedure TForm_record.FormDestroy(Sender: TObject);
begin
if  hHook<>0 then
begin
  UnHookWindowsHookEx(hHook);
  hHook := 0;
  Button1.Enabled := True;
  Button2.Enabled := False;
  Button3.Enabled:=False;
end;

end;

end.

