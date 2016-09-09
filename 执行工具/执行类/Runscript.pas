
unit Runscript;

interface
uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs,MY_API, lua, lualib,lauxlib, LuaUtils;

type
   PFCALLBACK = procedure(nt:String;_C:TColor);stdcall;


type      //�����߳���
  TScriptThread=class(TThread)
  private  
    User_Scr:TStringList;
    L:Plua_State;
    Hardwork:Boolean;
    Log:PFCALLBACK;

    

protected
  procedure Ready;
  procedure Execute; override;
  procedure OnDead(Sender: TObject);
public
   Running:boolean;
  constructor create();
end;

implementation


constructor TScriptThread.create();
begin
  inherited create(false);
  Ready;
  OnTerminate:=OnDead;
  freeonterminate:=true;//�߳���ֹʱ�Զ�ɾ������
end;



procedure TScriptThread.OnDead(Sender: TObject);
begin
 Running:=False;
 self:=nil;
end;

procedure TScriptThread.Execute;
begin
  try
   LuaLoadBuffer(L,User_Scr.Text, 'User_Scr');
   except
     on E: ELuaException do
        begin
        if (E.Msg <> 'STOP') then
          begin
           log(Format('[ERROR]:%s Line:%d',[E.Msg,E.Line]),CLRed);
          exit;
         end;
        end;
     end;
   lua_dobuffer(L,pchar(User_Scr.Text),length(User_Scr.Text),'User_Scr');
end;



procedure TScriptThread.Ready;
begin
User_Scr:=TStringList.Create;
if L<>nil then lua_close(L);
L := lua_open();
luaopen_base(L);
luaopen_table(L);
luaopen_io(L);
luaopen_string(L);
luaopen_math(L);
luaopen_loadlib(L);
luaopen_debug(L);

//ע�ắ��
lua_register(L,'print',API_print)  ;
//==����==
lua_register(L,'keypress',API_KeyPress)  ;
lua_register(L,'keydown',API_KeyDown)  ;
lua_register(L,'keyup',API_KeyUp)  ;
//==���==
lua_register(L,'leftclick',API_LeftClick)  ;
lua_register(L,'rightclick',API_RightClick)  ;
lua_register(L,'middleclick',API_MiddleClick)  ;
lua_register(L,'leftdblick',API_LeftDoubleClick)  ;
lua_register(L,'leftdown',API_LeftDown)  ;
lua_register(L,'leftup',API_LeftUp)  ;
lua_register(L,'rightdown',API_RightDown)  ;
lua_register(L,'rightup',API_RightUp)  ;
lua_register(L,'moveto',API_MoveTo)  ;
lua_register(L,'mover',API_MoveR)  ;
//==����===
lua_register(L,'sleep',API_Sleep)  ;
lua_register(L,'messagebox',API_messagebox)  ;
lua_register(L,'saystring',API_saystring)  ;
lua_register(L,'findpic',API_findpic)  ;
lua_register(L,'getpixelcolor',API_getpixelcolor)  ;

lua_register(L,'findcolor',API_findcolor)  ;
lua_register(L,'findcolorex',API_findcolorex)  ;
lua_register(L,'comparecolore',API_comparecolore)  ;
lua_register(L,'readmemory',API_readmemory)  ;

//===========ϵͳAPI================
lua_register(L,'findwindow',API_FindWindow)  ;
lua_register(L,'setwindowpos',API_SetWindowPos)  ;
lua_register(L,'playsound',API_PlaySound)  ;

lua_register(L,'gettickcount',API_GetTickCount)  ;

lua_register(L,'postmessage',API_PostMessage)  ;
lua_register(L,'sendmessage',API_SendMessage)  ;

end;



end.
