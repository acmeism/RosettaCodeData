# include "rational"; # a reminder that r/2 and power/1 are required

# Input: any JSON number, not only a decimal
# Output: a rational, constructed using r/2
# Requires power/1 (to take advantage of gojq's support for integer arithmetic)
# and r/2 (for rational number constructor)
def number_to_r:

  # input: a decimal string
  # $in - either null or the original input
  # $e  - the integer exponent of the original number, or 0
  def dtor($in; $e):
    index(".") as $ix
    | if $in and ($ix == null) then $in
      else (if $ix then sub("[.]"; "") else . end | tonumber) as $n
      | (if $ix then ((length - ($ix+1)) - $e) else - $e end) as $p
      | if $p >= 0
        then r( $n;   10|power($p))
        else r( $n * (10|power(-$p)); 1)
        end
     end;

    . as $in
    | tostring
    | if (test("[Ee]")|not) then dtor($in; 0)
      else capture("^(?<s>[^eE]*)[Ee](?<e>.*$)")
      | (.e | if length > 0 then tonumber else 0 end) as $e
      | .s | dtor(null; $e)
    end ;
