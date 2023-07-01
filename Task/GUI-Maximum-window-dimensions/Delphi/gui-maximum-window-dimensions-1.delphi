unit Main;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.Forms;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
 w,h:Integer;
begin
  w := Screen.Monitors[0].WorkareaRect.Width;
  h := Screen.Monitors[0].WorkareaRect.Height;
  Caption:= format('%d x %d',[w,h]);
  SetBounds(0,0,w,h);
end;

end.
