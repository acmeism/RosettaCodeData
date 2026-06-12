# If your jq includes until/2
# then feel free to omit the following definition:
def until(cond; next):
  def _until: if cond then . else (next|_until) end;  _until;
