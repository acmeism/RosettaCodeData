def toCamel:
  trim as $snake
  | { camel: "", underscore : false}
  | reduce ($snake|explode[]|[.]|implode) as $c (.;
      if ["_", "-", " "]|index($c)
      then .underscore = true
      elif .underscore
      then .camel += ($c|ascii_upcase)
      | .underscore = false
      else .camel += $c
      end)
  | .camel;

def toSnake:
  (trim | gsub("\\s"; "_")) as $camel
  | reduce ($camel|explode[1:][]|[.]|implode) as $c (
      $camel[0:1];
      if $c|isUpper
      then ($c|ascii_downcase) as $lc
      | if (.[-1:] | (. == "_" or . == "-"))
           then . + $lc
           else . +  "_" + $lc
           end
      else . + $c
      end );

def tests: [
    "snakeCase", "snake_case", "variable_10_case", "variable10Case", "ɛrgo rE tHis",
    "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "
];

"                          === to_snake_case ===",
(tests[] | "\(lpad(33)) -> \(toSnake)"),
"",
"                          === toCamelCase ===",
(tests[] | "\(lpad(33)) -> \(toCamel)")
