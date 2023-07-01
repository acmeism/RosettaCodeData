program Super_D;
uses
  sysutils,gmp;

var
  s :ansistring;
  s_comp : ansistring;
  test : mpz_t;
  i,j,dgt,cnt : NativeUint;
Begin
  mpz_init(test);

  for dgt := 2 to 9 do
  Begin
    //create '22' to '999999999'
    i := dgt;
    For j := 2 to dgt do
      i := i*10+dgt;
    s_comp := IntToStr(i);
    writeln('Finding ',s_comp,' in ',dgt,'*i**',dgt);

    i := dgt;
    cnt := 0;
    repeat
      mpz_ui_pow_ui(test,i,dgt);
      mpz_mul_ui(test,test,dgt);
      setlength(s,mpz_sizeinbase(test,10));
      mpz_get_str(pChar(s),10,test);
      IF Pos(s_comp,s) <> 0 then
      Begin
        write(i,' ');
        inc(cnt);
      end;
      inc(i);
    until cnt = 10;
    writeln;
  end;
  mpz_clear(test);
End.
