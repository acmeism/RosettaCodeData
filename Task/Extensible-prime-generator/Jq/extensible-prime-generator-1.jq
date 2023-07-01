# Recent versions of jq include the following definition:
# until/2 loops until cond is satisfied,
# and emits the value satisfying the condition:
def until(cond; next):
  def _until:
    if cond then . else (next|_until) end;
  _until;

def count(cond): reduce .[] as $x (0; if $x|cond then .+1 else . end);
