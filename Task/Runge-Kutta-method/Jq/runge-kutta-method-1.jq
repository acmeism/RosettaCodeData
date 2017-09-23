def until(cond; next):
  def _until: if cond then . else (next|_until) end;
  _until;

def while(cond; update):
  def _while:  if cond then ., (update | _while) else empty end;
  _while;
