program eidolon;

uses
  Forms,
  Windows,
  Dialogs,
  SysUtils,
  Anti_MoreApps,
  Cladmin in 'Cladmin.pas' {Form_Admin},
  Unit1 in 'Unit1.pas' {FrmMain},
  Cashpoint in 'Cashpoint.pas' {Cash_point},
  unitFrmMain in 'unitFrmMain.pas' {Form_record},
  WindowTool in 'WindowTool.pas' {Form_WINTOOL},
  about in 'about.pas' {AboutBox},
  SetLoop in 'SetLoop.pas' {Form_SetLoop},
  admin_setup in 'admin_setup.pas' {Form_adminSetup},
  lauxlib in 'lauxlib.pas',
  lua in 'Lua.pas',
  luaconf in 'LuaConf.pas',
  lualib in 'lualib.pas',
  LuaUtils in 'LuaUtils.pas',
  MY_API in 'MY_API.pas',
  MyWindows in 'MyWindows.pas',
  Run_script in 'Run_script.pas';

{$R *.res}


begin
if not HasApp('{303CC8EE-4ABD-4FA0-9AE4-353BEBFBACA6}') THEN
  BEGIN
 // showmessage('��ʼ����1');
  Application.Initialize;

  Application.CreateForm(TForm_Admin, Form_Admin);
  SetWindowPos(Form_Admin.Handle,   HWND_TOPMOST,   0,   0,   0,   0,   SWP_NOSIZE+SWP_NOMOVE);

  //showmessage('��ʼ����2');
  Application.CreateForm(TAboutBox, AboutBox);
  //showmessage('��ʼ����3');
  Application.CreateForm(TForm_SetLoop, Form_SetLoop);
  //showmessage('��ʼ����4');
  Application.CreateForm(TForm_adminSetup, Form_adminSetup);
  //showmessage('��ʼ����5');
  SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);
  //showmessage('��ʼ����6');
  Application.CreateForm(TFrmMain, FrmMain);
  //showmessage('��ʼ����7');
  Application.CreateForm(TCash_point, Cash_point);
  //showmessage('��ʼ����8');
  Application.CreateForm(TForm_WINTOOL, Form_WINTOOL);
  //showmessage('��ʼ����9');
  Application.CreateForm(TForm_record, Form_record);
  //showmessage('��ʼ����10');
  Application.Run;
  end; 
end.
