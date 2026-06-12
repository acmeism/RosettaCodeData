# Input: an array of strings
def longest_common_suffix:
  def r: explode | reverse | implode;
  if length == 0 then ""        # by convention
  elif length == 1 then .[0]    # for speed
  else map(r)
  | longest_common_prefix
  | r
  end;
