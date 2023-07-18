def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def Units: {
  "arshin"    : 0.7112,
  "centimeter": 0.01,
  "diuym"     : 0.0254,
  "fut"       : 0.3048,
  "kilometer" : 1000.0,
  "liniya"    : 0.00254,
  "meter"     : 1.0,
  "milia"     : 7467.6,
  "piad"      : 0.1778,
  "sazhen"    : 2.1336,
  "tochka"    : 0.000254,
  "vershok"   : 0.04445,
  "versta"    : 1066.8
};

def cyrillic: {
  "arshin"    : "арши́н",
  "centimeter": "сантиметр",
  "diuym"     : "дюйм",
  "fut"       : "фут",
  "kilometer" : "километр",
  "liniya"    : "ли́ния",
  "meter"     : "метр",
  "milia"     : "ми́ля",
  "piad"      : "пядь",
  "sazhen"    : "саже́нь",
  "tochka"    : "то́чка",
  "vershok"   : "вершо́к",
  "versta"    : "верста́"
};

def request:
  def explain: "number and unit of measurement expected vs \(.)" | error;
  def check:
    $ARGS.positional
    | if length >= 2
      then (try (.[0] | tonumber) catch false) as $n
      | (.[1] | sub("s$";"")) as $u
      | if $n and Units[$u] then [$n, $u]
        else explain
        end
      else explain
      end;
  check ;

# Input: a number
# Delete unhelpful digits
def humanize($n):
   tostring
   | ( capture("^(?<head>[0-9]*)[.](?<zeros>0*)(?<tail>[0-9]*)$")
       | (.head|length) as $hl
       | if $hl > $n then .head + "."
         elif .head | (. == "" or . == "0")
         then .head + "." + .zeros + .tail[:1 + $n - $hl]
         else .head + "." + (.zeros + .tail)[:1 + $n - $hl]
         end ) // .;

def display:
  Units
  | . as $Units
  | request as [$n, $unit]
  | "\($n) \($unit)\(if $n == 1 then "" else "s" end) ::",
    (to_entries[]
     | "\(.key|lpad(10)) : \(($n * $Units[$unit] / .value) | humanize(5)) \(cyrillic[.key])"),
    "" ;

display
