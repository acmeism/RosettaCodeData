declare
  Dict = {Dictionary.new}
in
  Dict.foo := 5
  Dict.bar := 10
  Dict.baz := 15
  Dict.foo := 20

  {Inspect Dict}
