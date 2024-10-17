type
  { TPoint }

  TMyPoint = class
  private
    FX: Integer;
    FY: Integer;
  public
    constructor Create; overload;
    constructor Create(X0: Integer; Y0: Integer); overload;
    constructor Create(MyPoint: TMyPoint); overload;
    destructor Destroy; override;

    procedure Print; virtual;

    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
  end;

  { TCircle }

  TCircle = class(TMyPoint)
  private
    FR: Integer;
  public
    constructor Create(X0: Integer; Y0: Integer; R0: Integer); overload;
    constructor Create(MyPoint: TMyPoint; R0: Integer); overload;
    constructor Create(Circle: TCircle); overload;
    destructor Destroy; override;

    procedure Print; override;

    property R: Integer read FR write FR;
  end;

implementation

uses Dialogs;

{ TCircle }

constructor TCircle.Create(X0: Integer; Y0: Integer; R0: Integer);
begin
  inherited Create(X0, Y0);
  FR := R0;
end;

constructor TCircle.Create(MyPoint: TMyPoint; R0: Integer);
begin
  inherited Create(MyPoint);
  FR := R0;
end;

constructor TCircle.Create(Circle: TCircle);
begin
  Create;
  if not(Circle = Self) then
  begin
    FX := Circle.X;
    FY := Circle.Y;
    FR := Circle.R;
  end;
end;

destructor TCircle.Destroy;
begin
  inherited Destroy;
end;

procedure TCircle.Print;
begin
   ShowMessage('Circle');
end;

{ TMyPoint }

constructor TMyPoint.Create;
begin
  inherited Create;
end;

constructor TMyPoint.Create(X0: Integer; Y0: Integer);
begin
  Create;
  FX := X0;
  FY := Y0;
end;

constructor TMyPoint.Create(MyPoint: TMyPoint);
begin
  Create;
  if not(MyPoint = Self) then
  begin
    FX := MyPoint.X;
    FY := MyPoint.Y;
  end;
end;

destructor TMyPoint.Destroy;
begin
  inherited Destroy;
end;

procedure TMyPoint.Print;
begin
  ShowMessage('MyPoint');
end;
