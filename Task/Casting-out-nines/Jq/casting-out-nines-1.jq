def co9:
  def digits: tostring | explode | map(. - 48);  # "0" is 48
  if . == 9 then 0
  elif 0 <= . and . <= 8 then .
  else digits | add | co9
  end;
