type
  [Serializable]
  Base = class
  public
    fb: integer;
    constructor (fb: integer) := Self.fb := fb;
    function ToString: string; override := fb.ToString;
  end;

  [Serializable]
  Derived = class(Base)
  public
    fd: real;
    constructor (fb: integer; fd: real);
    begin
      inherited Create(fb);
      Self.fd := fd;
    end;
    function ToString: string; override := inherited ToString + ',' + fd.ToString;
  end;

begin
  var lst := new List<Base>;
  lst.Add(new Base(3));
  lst.Add(new Derived(4,5.5));
  lst.Add(new Base(6));
  lst.Add(new Derived(7,8.8));
  lst.Println;
  Serialize('objects.dat',lst);
  var lst1 := DeSerialize('objects.dat') as List<Base>;
  lst1.Println;
end.
