Program BestShuffle;

Const
  arr : array[1..6] Of string = ('abracadabra','seesaw','elk','grrrrrr','up','a');

Function Shuffle(inp: String): STRING;

Var x,ReplacementDigit : longint;
  ch : char;
Begin
  If length(inp) > 1 Then
    Begin
      Randomize;
      For x := 1 To length(inp) Do
        Begin
          Repeat
            ReplacementDigit := random(length(inp))+1;
          Until (ReplacementDigit <> x);
          ch := inp[x];
          inp[x] := inp[ReplacementDigit];
          inp[ReplacementDigit] := ch;
        End;
    End;
  shuffle := inp;
End;


Function score(OrgString,ShuString : String) : integer;

Var i : integer;
Begin
  score := 0;
  For i := 1 To length(OrgString) Do
    If OrgString[i] = ShuString[i] Then inc(score);
End;

Var i : integer;
  shuffled : string;
Begin
  For i := low(arr) To high(arr) Do
    Begin
      shuffled := shuffle(arr[i]);
      writeln(arr[i],' , ',shuffled,' , (',score(arr[i],shuffled),')');
    End;
End.
