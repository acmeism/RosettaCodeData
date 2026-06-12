def is_nice:
  # input: a non-negative integer
  def sumn:
    . as $in
    | tostring
    | if length == 1 then $in
      else explode | map([.] | implode | tonumber) | add | sumn
      end;

  is_prime and (sumn|is_prime);

# The task:
range(501; 1000) | select(is_nice)
