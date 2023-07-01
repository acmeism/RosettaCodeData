unit Printer;

interface

type
  // the "delegate"
  TRealPrinter = class
  public
    procedure Print;
  end;

  // the "delegator"
  TPrinter = class
  private
    FPrinter: TRealPrinter;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Print;
  end;

implementation

{ TRealPrinter }

procedure TRealPrinter.Print;
begin
   Writeln('Something...');
end;

{ TPrinter }

constructor TPrinter.Create;
begin
  inherited Create;
  FPrinter:= TRealPrinter.Create;
end;

destructor TPrinter.Destroy;
begin
  FPrinter.Free;
  inherited;
end;

procedure TPrinter.Print;
begin
  FPrinter.Print;
end;

end.
