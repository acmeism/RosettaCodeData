type
  TMyObject = class(TObject)
  public
    procedure AbstractFunction; virtual; abstract; // Your virtual abstract function to overwrite in descendant
    procedure ConcreteFunction; virtual; // Concrete function calling the abstract function
  end;

implementation

procedure TMyObject.ConcreteFunction;
begin
  AbstractFunction; // Calling the abstract function
end;
