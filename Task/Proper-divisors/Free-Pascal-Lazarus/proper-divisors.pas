Program ProperDivisors;

Uses fgl;

Type
  TIntegerList = Specialize TfpgList<longint>;

Var list : TintegerList;

Function GetProperDivisors(x : longint): longint;
{this function will return the number of proper divisors
 and put them in the list}

Var i : longint;
Begin
  list.clear;
  If x = 1 Then {by default 1 has no proper divisors}
    GetProperDivisors := 0
  Else
    Begin
      list.add(1); //add 1 as a proper divisor;
      i := 2;
      While i * i < x Do
        Begin
          If (x Mod i) = 0 Then //found a proper divisor
            Begin
              list.add(i); // add divisor
              list.add(x Div i); // add result
            End;
          inc(i);
        End;
      If i*i=x Then list.add(i); //make sure to capture the sqrt only once
      GetProperDivisors := list.count;
    End;
End;

Var i,j,count,most : longint;
Begin

  list := TIntegerList.Create;
  For i := 1 To 10 Do
    Begin
      write(i:4,' has ', GetProperDivisors(i),' proper divisors:');
      For j := 0 To pred(list.count) Do
        write(list[j]:3);
      writeln();
    End;
  count := 0; //store highest number of proper divisors
  most := 0;  //store number with highest number of proper divisors
  For i := 1 To 20000 Do
    If GetProperDivisors(i) > count Then
      Begin
        count := list.count;
        most := i;
      End;
  writeln(most,' has ',count,' proper divisors');
  list.free;
End.
