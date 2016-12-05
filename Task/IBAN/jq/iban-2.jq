def letters2digits:
  65 as $A | 90 as $Z
  | ($A - 10) as $ten
  | explode
  | map( if $A <= . and . <= $Z
         then (. - $ten) | tostring
         else [.] | implode
         end )
  | join("");

# jq currently does not have unlimited-precision integer arithmetic
# and so we define a special-purpose "mod 97" filter:
# input: a string representing a decimal
# output: its remainder modulo 97 as a number
def remainder:
  if length < 15 then (.|tonumber) % 97
  else (.[0:14] | remainder | tostring) as $r1
       | ($r1 + .[14:]) | remainder
  end;

def is_valid_iban:
  {
    "AL": 28, "AD": 24, "AT": 20, "AZ": 28, "BE": 16, "BH": 22, "BA": 20, "BR": 29,
    "BG": 22, "CR": 21, "HR": 21, "CY": 28, "CZ": 24, "DK": 18, "DO": 28, "EE": 20,
    "FO": 18, "FI": 18, "FR": 27, "GE": 22, "DE": 22, "GI": 23, "GR": 27, "GL": 18,
    "GT": 28, "HU": 28, "IS": 26, "IE": 22, "IL": 23, "IT": 27, "KZ": 20, "KW": 30,
    "LV": 21, "LB": 28, "LI": 21, "LT": 20, "LU": 20, "MK": 19, "MT": 31, "MR": 27,
    "MU": 30, "MC": 27, "MD": 24, "ME": 22, "NL": 18, "NO": 15, "PK": 24, "PS": 29,
    "PL": 28, "PT": 25, "RO": 24, "SM": 27, "SA": 24, "RS": 22, "SK": 24, "SI": 19,
    "ES": 24, "SE": 24, "CH": 21, "TN": 24, "TR": 26, "AE": 23, "GB": 22, "VG": 24
  } as $lengths
  # Ignore spaces and tabs, and check input is ALPHAnumeric:
  | gsub("[ \t]";"")
  | test("^[A-Z0-9]+$")
      # Validate country code against expected length:
      and length == $lengths[.[0:2]]
      # Shift and convert:
      and ( (.[4:] + .[0:4]) | letters2digits | remainder) == 1 ;
