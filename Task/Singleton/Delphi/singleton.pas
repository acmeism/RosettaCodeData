unit Singleton;

interface

type
  TSingleton = class
  private
    //Private fields and methods here...

     class var _instance: TSingleton;
  protected
    //Other protected methods here...
  public
    //Global point of access to the unique instance
    class function Create: TSingleton;

    destructor Destroy; override;

    //Other public methods and properties here...
  end;

implementation

{ TSingleton }

class function TSingleton.Create: TSingleton;
begin
  if (_instance = nil) then
    _instance:= inherited Create as Self;

  result:= _instance;
end;

destructor TSingleton.Destroy;
begin
  _instance:= nil;
  inherited;
end;

end.
