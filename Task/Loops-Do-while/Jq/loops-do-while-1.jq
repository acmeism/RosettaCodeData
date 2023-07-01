# Perform the action, then check the condition, etc
def do_while( action; condition ):
  def w: action | if (condition | not) then empty else ., w end;
  w;
