main:(

  MODE COLOR = BITS;
  FORMAT color repr = $"16r"16r6d$;

  # This is an associative array which maps strings to ints #
  MODE ITEM = STRUCT(STRING key, COLOR value);
  REF[]ITEM color map items := LOC[0]ITEM;

  PROC color map find = (STRING color)REF COLOR:(
    REF COLOR out;
# linear search! #
    FOR index FROM LWB key OF color map items TO UPB key OF color map items DO
      IF color = key OF color map items[index] THEN
        out := value OF color map items[index]; GO TO found
      FI
    OD;
      NIL EXIT
    found:
      out
  );

  PROC color map = (STRING color)REF COLOR:(
    REF COLOR out = color map find(color);
    IF out :=: REF COLOR(NIL) THEN # extend color map array #
      HEAP[UPB key OF color map items + 1]ITEM color map append;
      color map append[:UPB key OF color map items] := color map items;
      color map items := color map append;
      value OF (color map items[UPB value OF color map items] := (color, 16r000000)) # black #
    ELSE
      out
    FI
  );

  # First, populate it with some values #
  color map("red") := 16rff0000;
  color map("green") := 16r00ff00;
  color map("blue") := 16r0000ff;
  color map("my favourite color") := 16r00ffff;

  # then, get some values out #
  COLOR color := color map("green"); # color gets 16r00ff00 #
  color := color map("black"); # accessing unassigned values assigns them to 16r0 #

  # get some value out without accidentally inserting new ones #
  REF COLOR value = color map find("green");
  IF value :=: REF COLOR(NIL) THEN
    put(stand error, ("color not found!", new line))
  ELSE
    printf(($"green: "f(color repr)l$, value))
  FI;

  # Now I changed my mind about my favourite color, so change it #
  color map("my favourite color") := 16r337733;

  # print out all defined colors #
  FOR index FROM LWB color map items TO UPB color map items DO
    ITEM item = color map items[index];
    putf(stand error, ($"color map("""g""") = "f(color repr)l$, item))
  OD;

  FORMAT fmt;
  FORMAT comma sep = $"("n(UPB color map items-1)(f(fmt)", ")f(fmt)")"$;

  fmt := $""""g""""$;
  printf(($g$,"keys: ", comma sep, key OF color map items, $l$));
  fmt := color repr;
  printf(($g$,"values: ", comma sep, value OF color map items, $l$))

)
