INT trials = 1 000 000;

MODE LREAL = LONG REAL;

MODE ITEM = STRUCT(
  STRING name,
  INT prob count,
  LREAL expect,
        mapping
);
INT col width = 9;
FORMAT real repr = $g(-col width+1, 6)$,
       item repr = $"Name: "g", Prob count: "g(0)", Expect: "f(real repr)", Mapping: ", f(real repr)l$;

[8]ITEM items := (
  ( "aleph",  0, ~, ~ ),
  ( "beth",   0, ~, ~ ),
  ( "gimel",  0, ~, ~ ),
  ( "daleth", 0, ~, ~ ),
  ( "he",     0, ~, ~ ),
  ( "waw",    0, ~, ~ ),
  ( "zayin",  0, ~, ~ ),
  ( "heth",   0, ~, ~ )
);

main:
(
  LREAL offset = 5; # const #

# initialise items #
  LREAL total sum := 0;
  FOR i FROM LWB items TO UPB items - 1 DO
    expect OF items[i] := 1/(i-1+offset);
    total sum +:= expect OF items[i]
  OD;
  expect OF items[UPB items] := 1 - total sum;

  mapping OF items[LWB items] := expect OF items[LWB items];
  FOR i FROM LWB items + 1 TO UPB items DO
    mapping OF items[i] := mapping OF items[i-1] + expect OF items[i]
  OD;

  # printf((item repr, items)) #

# perform the sampling #
  PROC sample = (REF[]LREAL mapping)INT:(
    INT out;
    LREAL rand real = random;
    FOR j FROM LWB items TO UPB items DO
      IF rand real < mapping[j] THEN
        out := j;
	done
      FI
    OD;
    done: out
  );

  FOR i TO trials DO
      prob count OF items[sample(mapping OF items)] +:= 1
  OD;

  FORMAT indent = $17k$;

# print the results #
  printf(($"Trials: "g(0)l$, trials));
  printf(($"Items:"$,indent));
  FOR i FROM LWB items TO UPB items DO printf(($gn(col width)k" "$, name OF items[i])) OD;
  printf(($l"Target prob.:"$, indent, $f(real repr)" "$, expect OF items));
  printf(($l"Attained prob.:"$, indent));
  FOR i FROM LWB items TO UPB items DO printf(($f(real repr)" "$, prob count OF items[i]/trials)) OD;
  printf($l$)
)
