# strip the input string of spaces and tabs:
gsub("[ \t]";"")
# check the string is ALPHAnumeric
| test("^[A-Z0-9]+$")
  # check its length is as determined by the country code:
  and length == $lengths[.[0:2]]
  # check the mod 97 criterion:
  and ( (.[4:] + .[0:4]) | letters2digits | remainder) == 1
