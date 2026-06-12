def number_decimal_digits:
  . as $in
  | def nil: . == null or . == "";
  def nodecimal: # e.g. 12 or 12e-2
    capture("^[-+]?[0-9]*([eE](?<sign>[-+]?)(?<p>[0-9]+))?$")
    | if .sign|nil then 0
      elif .p|nil then "internal error: \($in)"|error
      else .p|tonumber
      end;
  tostring
  | nodecimal
    // capture("^[-+]?[0-9]*[.](?<d>[0-9]+)([eE](?<sign>[-+]?)(?<p>[0-9]+))?$") # has decimal
    // null
  | if type == "number" then .
    elif not then 0
    elif .d|nil then 0
    elif (.sign|nil) and .p == null then .d|length
    elif (.sign|nil) or .sign == "+" then [0, (.d|length) - (.p|tonumber)] | max
    elif .sign == "-" then (.d|length) + (.p|tonumber)
    else "internal error: \($in)"|error
    end ;

def examples:
   [12.345,    3],
   [12.3450,   4],
   ["12.3450", 4],
   [1e-2,      2],
   [1.23e2,    0];

def task:
  examples
  | (first|number_decimal_digits) as $d
  | if $d == last then empty
    else "\(first) has \(last) decimal places but the computed value is \($d)"
    end;

task, "Bye."
