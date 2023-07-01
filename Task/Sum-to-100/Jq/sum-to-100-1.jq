# Generate a "sum" in the form:  [I, 1, X, 2, X, 3, ..., X, n] where I is "-" or "", and X is "+", "-", or ""
def generate(n):
  def pm: ["+"], ["-"], [""];

  if n == 1 then (["-"], [""]) + [1]
  else generate(n-1) + pm +  [n]
  end;

# The numerical value of a "sum"
def addup:
  reduce .[] as $x ({sum:0, previous: "0"};
     if   $x == "+" then .sum += (.previous|tonumber) | .previous = ""
     elif $x == "-" then .sum += (.previous|tonumber) | .previous = "-"
     elif $x == "" then .
     else .previous += ($x|tostring)
     end)
     | .sum + (.previous | tonumber) ;

# Pretty-print a "sum", e.g. ["",1,"+", 2] => 1 + 2
def pp: map(if . == "+" or . == "-" then " " + . else tostring end) | join("");
