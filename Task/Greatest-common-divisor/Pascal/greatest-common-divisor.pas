program GCF (INPUT, OUTPUT);
  var
    a,b,c:integer;
  begin
    writeln('Enter 1st number');
    read(a);
    writeln('Enter 2nd number');
    read(b);
    while (a*b<>0)
      do
      begin
        c:=a;
        a:=b mod a;
        b:=c;
      end;
    writeln('GCF :=', a+b );
  end.
