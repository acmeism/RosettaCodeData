def parse:

  def uc: .name | ascii_upcase;

  def parse_boolean:
    capture( "(?<name>^[^ ] *$)" )
    | { (uc) : true };

  def parse_var_value:
    capture( "(?<name>^[^ ]+)[ =] *(?<value>[^,]+ *$)" )
    | { (uc) : .value };

  def parse_var_array:
    capture( "(?<name>^[^ ]+)[ =] *(?<value>.*)" )
    | { (uc) : (.value | sub(" +$";"") | [splits(", *")]) };

  reduce inputs as $i ({};
    if $i|length == 0 or test("^[#;]") then .
    else . + ($i | ( parse_boolean // parse_var_value // parse_var_array // {} ))
    end);

parse
