def check($p; $result):
  if getjsonpointer($p) == $result
  then empty
  else "whoops: \($p)"
  end;

def checkError($p):
  (try getjsonpointer($p) catch nan)
  | . as $result
  | if isnan then empty
    else "\($p) should have raised an error but yielded \($result)"
    end;

check(""; .), #   The entire input document.
check("/";  "Rosetta"),
check("/ "; "Code"),
check("/abc";  ["is", "a"]),
check("/def/"; "programming"),
check("/g~1h"; "chrestomathy"),
check("/i~0j"; "site"),
check("/wiki/links/0";  "https://rosettacode.org/wiki/Rosetta_Code"),
check("/wiki/links/1";  "https://discord.com/channels/1011262808001880065"),

checkError("/wiki/links/2"),
checkError("/wiki/name"),
checkError("/no/such/thing"),
checkError("bad/pointer")
