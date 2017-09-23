# round(keep) takes as input any jq (i.e. JSON) number and emits a string.
# "keep" is the desired maximum number of numerals after the decimal point,
# e.g. 9.999|round(2) => 10.00
def round(keep):
  tostring
  | (index("e") | if . then . else index("E") end) as $e
  | if $e then (.[0:$e] | round(keep)) + .[$e+1:]
    else index(".") as $ix
      | if $ix == null then .
        else .[0:$ix + 1] as $head
          | .[$ix+1:$ix+keep+2] as $tail
          | if ($tail|length) <= keep then $head + $tail
            else ($tail | .[length-1:] | tonumber) as $last
              | if $last < 5 then  $head + $tail[0:$tail|length - 1]
                else (($head + $tail) | length) as $length
                  | ($head[0:-1] + $tail)
                  | (tonumber +  (if $head[0:1]=="-" then -5 else 5 end))
                  | tostring
                  | .[0: ($ix+1+length-$length)] + "." + .[length-keep-1:-1]
                end
            end
        end
    end;

def k2c: . - 273.15;
def k2f: . * 1.8 - 459.67;
def k2r: . * 1.8;

# produce a stream
def cfr:
  if . >= 0
  then "Kelvin: \(.)", "Celsius: \(k2c|round(2))",
       "Fahrenheit: \(k2f|round(2))", "Rankine: \(k2r|round(2))"
  else error("cfr: \(.) is an invalid temperature in degrees Kelvin")
  end;

cfr
