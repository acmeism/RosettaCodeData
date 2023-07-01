# In case your jq does not have "until" defined:
def until(cond; next):
  def _until:
    if cond then . else (next|_until) end;
  _until;
