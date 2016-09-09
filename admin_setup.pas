unit admin_setup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,IniFiles;

type
  TForm_adminSetup = class(TForm)
    GroupBox1: TGroupBox;
    chk_NotAdmin: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    CheckBox_Mouse: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ReadSetup;
    procedure WriteSetup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure chk_NotAdminClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_adminSetup: TForm_adminSetup;
implementation
 uses
 Cladmin;
{$R *.dfm}
procedure TForm_adminSetup.ReadSetup;
begin
    chk_NotAdmin.Checked:=Setup.ReadBool('ϵͳ����','�ǹ���Աģʽ',False);
    CheckBox_Mouse.Checked:=Setup.ReadBool('ϵͳ����','¼�����·��',False);
  end;

procedure TForm_adminSetup.WriteSetup;
begin
    Setup.WriteBool('ϵͳ����','�ǹ���Աģʽ',chk_NotAdmin.Checked);
    Setup.WriteBool('ϵͳ����','¼�����·��',CheckBox_Mouse.Checked);
  end;

procedure TForm_adminSetup.FormCreate(Sender: TObject);
begin
  ReadSetup;  //������
end;

procedure TForm_adminSetup.Button1Click(Sender: TObject);
begin
  WriteSetup;
  Form_adminSetup.Close;
end;

procedure TForm_adminSetup.Button2Click(Sender: TObject);
begin
Form_adminSetup.Close;
end;

procedure TForm_adminSetup.chk_NotAdminClick(Sender: TObject);
begin
if chk_NotAdmin.Checked then
begin
    if Application.MessageBox('ʹ�÷ǹ���Ա����,��������ʹ��Ӳ��ģ�⹦��,' + 
      #13#10 + 'ֻ�������ڲ�����������ִ�����������,����Ҫ' + #13#10 +
      'ʹ�÷ǹ���Աģʽ����,��ȷ��Ҫ��ô����?', '��ʾ', MB_YESNO +
      MB_ICONQUESTION + MB_TOPMOST) = IDNO then
    begin
      chk_NotAdmin.Checked:=False;
    end;


  end;
end;

end.
