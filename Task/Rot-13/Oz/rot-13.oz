declare
  fun {RotChar C}
     if     C >= &A andthen C =< &Z then &A + (C - &A + 13) mod 26
     elseif C >= &a andthen C =< &z then &a + (C - &a + 13) mod 26
     else C
     end
  end

  fun {Rot13 S}
     {Map S RotChar}
  end
in
  {System.showInfo {Rot13 "NOWHERE Abjurer 42"}}
  {System.showInfo {Rot13 {Rot13 "NOWHERE Abjurer 42"}}}
