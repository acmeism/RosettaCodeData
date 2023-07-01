# This filter may be applied to integers or integer-valued strings
def luhntest:
  def digits: tostring | explode | map([.]|implode|tonumber);
  (digits | reverse)
  | ( [.[range(0;length;2)]] | add ) as $sum1
  | [.[range(1;length;2)]]
  | (map( (2 * .) | if . > 9 then (digits|add) else . end) | add) as $sum2
  | ($sum1 + $sum2) % 10 == 0;

def decodeBase36:
  # decode a single character
  def d1:
    explode[0]
    # "0" is 48; "A" is 65
    | if . < 65 then . - 48
      else . - 55
      end;
  def chars: explode | map([.]|implode);
  chars | map(d1) | join("");

def is_ISIN:
  type == "string"
  and test("^(?<cc>[A-Z][A-Z])(?<sc>[0-9A-Z]{9})(?<cs>[0-9])$")
  and (decodeBase36 | luhntest);
