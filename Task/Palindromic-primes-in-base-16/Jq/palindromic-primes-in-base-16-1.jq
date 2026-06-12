# '''Preliminaries'''

def emit_until(cond; stream): label $out | stream | if cond then break $out else . end;

# decimal number to exploded hex array
def exploded_hex:
  def stream:
    recurse(if . > 0 then ./16|floor else empty end) | . % 16 ;
  if . == 0 then [48]
  else [stream] | reverse | .[1:]
  |  map(if . < 10 then 48 + . else . + 87 end)
  end;
