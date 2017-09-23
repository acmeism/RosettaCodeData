def while(cond; update):
  def _while: if cond then ., (update | _while) else empty end;
  _while;
