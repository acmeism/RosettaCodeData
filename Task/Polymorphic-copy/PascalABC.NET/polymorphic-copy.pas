type
  Base = class
  public
    fb: integer;
    constructor (fb: integer) := Self.fb := fb;
    function ToString: string; override := fb.ToString;
    function Clone: Base; virtual := new Base(fb);
  end;

  Derived = class(Base)
  public
    fd: real;
    constructor (fb: integer; fd: real);
    begin
      inherited Create(fb);
      Self.fd := fd;
    end;
    function ToString: string; override := inherited ToString + ',' + fd.ToString;
    function Clone: Base; override := new derived(fb,fd);
  end;

begin
  var lst := new List<Base>;
  lst.Add(new Base(3));
  lst.Add(new Derived(4,5.5));
  lst.Add(new Base(6));
  lst.Add(new Derived(7,8.8));
  lst.Println;
  var lst1 := new List<Base>;
  foreach var obj in lst do
    lst1.Add(obj.Clone);
  lst1.Println;
end.
