{
�Ƚ�����ϣ��   MakeIdentTable
  ������Creat ����
Creat -> ��ʼ��������   InitIdent
����������,�Բ�ͬ���ַ�ʹ�ò�ͬ�� ��������  MakeMethodTables
���õ�ǰ�����Ͷ���Ϊ δ֪  ResetRange

  SetLine -> Next -> ����������͵ĺ��� [IdentProc ...]  ->ͨ������������ҵ���Ӧ�� [IdentKind ]
->KeyHash ->KeyComp-GetEOL  ->Next  

AddHighlightToken(sToken, nTokenPos, nTokenLen, attr.Foregroun
                   �ؼ���  ��ʼλ��   ����
}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SynEdit,pretreatment;

type
  TForm1 = class(TForm)
    SynEdit1: TSynEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  SynHighlighterSample;

procedure TForm1.FormCreate(Sender: TObject);
var
  HL: TSynSampleSyn;
begin
  HL := TSynSampleSyn.Create(Self);
  SynEdit1.Highlighter := HL;
  
  SynEdit1.ClearAll;
  SynEdit1.Text := HL.SampleSource;
end;

end.
