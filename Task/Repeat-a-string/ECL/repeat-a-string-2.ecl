RepeatString(STRING InStr, INTEGER Cnt) := FUNCTION
  rec := {STRING Str};
  ds  := DATASET(Cnt,TRANSFORM(rec,SELF.Str := InStr));
  res := ITERATE(ds,TRANSFORM(rec,SELF.Str := LEFT.Str + RIGHT.Str));
  RETURN Res[Cnt].Str;
END;

RepeatString('ha',3);
RepeatString('Who',2);
