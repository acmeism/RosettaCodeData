def sorted:
  def until(cond; next):
     def _until: if cond then . else (next|_until) end;
     _until;

  length as $length
  | if $length <= 1 then true
    else . as $in
    | 1 | until( . == $length or $in[.-1] > $in[.] ; .+1) == $length
  end;
