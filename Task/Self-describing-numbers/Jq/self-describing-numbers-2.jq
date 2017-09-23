def selfie:
  def count(value): reduce .[] as $i (0; if $i == value then . + 1 else . end);
  def digits: tostring | explode | map(. - 48);

  digits
  | if  add != length then false
    else . as $digits
    | all ( range(0; length); . as $i | $digits | (.[$i] == count($i)) )
    end;
