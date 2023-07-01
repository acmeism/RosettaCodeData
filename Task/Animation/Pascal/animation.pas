program HelloWorldAnimatedGUI;

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  Classes,
  Controls,
  StdCtrls,
  ExtCtrls;

type
  { TFrmHelloWorldAnim }
  TFrmHelloWorldAnim = class(TForm)
    constructor CreateNew(AOwner: TComponent; Num: integer = 0); override;
    procedure lblTextAnimateClick(Sender: TObject);
    procedure tmrAnimateTimer(Sender: TObject);
  private
    { private declarations }
    lblTextAnimate: TLabel;
    tmrAnimate: TTimer;
    FDirection: boolean;
  public
    { public declarations }
  end;

var
  FrmHelloWorldAnim: TFrmHelloWorldAnim;

  { TFrmHelloWorldAnim }

  constructor TFrmHelloWorldAnim.CreateNew(AOwner: TComponent; Num: integer);
  begin
    inherited CreateNew(AOwner, Num);
    Height := 50;
    lblTextAnimate := TLabel.Create(self);
    with lblTextAnimate do
    begin
      Caption := 'Hello World! ';
      Align := alClient;
      Alignment := taCenter;
      font.Name := 'Courier New';
      font.size := 20;
      OnClick := @lblTextAnimateClick;
      Parent := self;
    end;
    tmrAnimate := TTimer.Create(self);
    with tmrAnimate do
    begin
      Interval := 100;
      OnTimer := @tmrAnimateTimer;
    end;
  end;

  procedure TFrmHelloWorldAnim.lblTextAnimateClick(Sender: TObject);
  begin
    FDirection := not FDirection;
  end;

  procedure TFrmHelloWorldAnim.tmrAnimateTimer(Sender: TObject);
  begin
    if FDirection then
      lblTextAnimate.Caption :=
        copy(lblTextAnimate.Caption, length(lblTextAnimate.Caption), 1) +
        copy(lblTextAnimate.Caption, 1, length(lblTextAnimate.Caption) - 1)
    else
      lblTextAnimate.Caption :=
        copy(lblTextAnimate.Caption, 2, length(lblTextAnimate.Caption) - 1) +
        copy(lblTextAnimate.Caption, 1, 1);
  end;

begin
  RequireDerivedFormResource := False;
  Application.Initialize;
  Application.CreateForm(TFrmHelloWorldAnim, FrmHelloWorldAnim);
  Application.Run;
end.
