# 20240905 Raku programming solution

use JSON::Fast;
use JSON::Pointer;

my $json = from-json q:to/END/;
{
  "wiki": {
    "links": [
      "https://rosettacode.org/wiki/Rosetta_Code",
      "https://discord.com/channels/1011262808001880065"
    ]
  },
  "": "Rosetta",
  " ": "Code",
  "g/h": "chrestomathy",
  "i~j": "site",
  "abc": ["is", "a"],
  "def": { "": "programming" }
}
END

for "",  "/",  "/ ", "/abc",   "/def", "/g~1h", "/i~0j",
    "/wiki/links/0", "/wiki/links/1" , "/wiki/links/2" ,
    "/wiki/name"   , "/no/such/thing", "bad/pointer"     -> $input {
   say "{$input.fmt: '%13s'} => ", ( $input eq "/" and $json{""}.defined )
      ?? $json{""} # :-P
      !! JSON::Pointer.parse($input).resolve($json);
   CATCH { default { say "Error: $_" } }
}
