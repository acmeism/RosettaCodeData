(* A mixture of the lyrics found in Wikipedia and the Ada version
   in Rosetta Code. It formats the lyrics like the Wikipedia one  *)
program OldLady;

uses
  SysUtils;

const
  MaxLadies = 9; //Number of iterations and array items
  Animals: array[1..MaxLadies + 1] of shortstring = (  //Add one for the song's end
    'fly',
    'spider',
    'bird',
    'cat',
    'dog',
    'pig',
    'goat',
    'cow',
    'donkey',
    'horse'
    );

  Verse1 = 'There was an old lady who swallowed a %s;';
  //Verse 2 variations
  Verse2Var1 = '   %s'; //Doubles as a spacing formatter
  Verse2Var2 = '   %s to swallow a %s;';
  Verse2Var3 = '   %s and swallowed a %s';
  Verse2Var4 = '   %s she swallowed a %s';
  Verse3 = '   She swallowed the %s to catch the %s;';
  VerseEnd = 'I don''t know why she swallowed a fly - perhaps she''ll die!';
  SongEnd = '   ...She''s dead of course!';

  SwallowResult: array[1..MaxLadies] of shortstring = (
    VerseEnd,
    'That wiggled and jiggled and tickled inside her!',
    'Quite absurd',
    'Fancy that',
    'What a hog,',
    'Her mouth was so big',
    'She just opened her throat',
    'I don''t know how',
    'It was rather wonky'
    );

  procedure PrintSong;
  var
    i, j: byte;
    SwallowStr: shortstring;

  begin
    for i := 1 to MaxLadies do
    begin
      WriteLn(Format(Verse1, [Animals[i]]));
      case i of
        1..2: SwallowStr := Verse2Var1;
        3..5: SwallowStr := Verse2Var2;
        6, 8..9: SwallowStr := Verse2Var4;
        else
          SwallowStr := Verse2Var3;
      end;
      WriteLn(Format(SwallowStr, [SwallowResult[i], Animals[i]]));
      if i >= 2 then
      begin
        for j := i downto 2 do
        begin
          WriteLn(Format(Verse3, [Animals[j], Animals[j - 1]]));
          if (j - 1 = 2) and (i >= 3) then
            WriteLn(Format(Verse2Var1, [SwallowResult[2]]));
        end;
        if j >= 2 then
          WriteLn(Format(Verse2Var1, [VerseEnd]));
      end;
    end;
    WriteLn(Format(Verse1, [Animals[MaxLadies + 1]]));
    WriteLn(SongEnd);
  end;

begin
  PrintSong;
end.
