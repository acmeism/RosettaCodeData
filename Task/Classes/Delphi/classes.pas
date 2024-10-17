program SampleClass;

{$APPTYPE CONSOLE}

type
  TMyClass = class
  private
    FSomeField: Integer; // by convention, fields are usually private and exposed as properties
  public
    constructor Create;
    destructor Destroy; override;
    procedure SomeMethod;
    property SomeField: Integer read FSomeField write FSomeField;
  end;

constructor TMyClass.Create;
begin
  FSomeField := -1
end;

destructor TMyClass.Destroy;
begin
  // free resources, etc

  inherited Destroy;
end;

procedure TMyClass.SomeMethod;
begin
  // do something
end;


var
  lMyClass: TMyClass;
begin
  lMyClass := TMyClass.Create;
  try
    lMyClass.SomeField := 99;
    lMyClass.SomeMethod();
  finally
    lMyClass.Free;
  end;
end.
