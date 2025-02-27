Program Ordered_Words;
{$mode ObjFPC}{$H+}

Uses
Classes;

Const
  FILENAME = 'unixdict.txt';

Function IsOrdered(Const S: String): boolean;

Var
  I, Len: integer;
Begin
  Len := Length(S);
  If Len < 2 Then
    Exit(True);
  For I := 2 To Len Do
    If S[I] < S[I - 1] Then
      Exit(False);
  Result := True;
End;

Var
  WordList, OrderedWords: TStringList;
  CurrentWord: string;
  CurrentLength, LongestLength: integer;

Begin
  LongestLength := 0;
  WordList := TStringList.Create;
  OrderedWords := TStringList.Create;

  WordList.LoadFromFile(FILENAME);
  For CurrentWord In WordList Do
    Begin
      CurrentLength := Length(CurrentWord);
      If CurrentLength >= LongestLength Then
        If IsOrdered(CurrentWord) Then
          If CurrentLength > LongestLength Then
            Begin
              LongestLength := CurrentLength;
              OrderedWords.Clear;
              OrderedWords.Add(CurrentWord);
            End
      Else If CurrentLength = LongestLength Then
             OrderedWords.Add(CurrentWord);
    End;
  For CurrentWord In OrderedWords Do
    WriteLn(CurrentWord);

  WordList.Free;
  OrderedWords.Free;
End.
