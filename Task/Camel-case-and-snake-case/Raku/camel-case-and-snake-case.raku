my @tests = qww<
  snakeCase  snake_case  variable_10_case  variable10Case  "ɛrgo rE tHis"
  hurry-up-joe!  c://my-docs/happy_Flag-Day/12.doc  "  spaces  "
>;


sub to_snake_case (Str $snake_case_string is copy) {
    $snake_case_string.=trim;
    return $snake_case_string if $snake_case_string.contains: / \s | '/' /;
    $snake_case_string.=subst: / <after <:Ll>> (<:Lu>|<:digit>+) /, {'_' ~ $0.lc}, :g;
    $snake_case_string.=subst: / <after <:digit>> (<:Lu>) /, {'_' ~ $0.lc}, :g;
}

sub toCamelCase (Str $CamelCaseString is copy) {
    $CamelCaseString.=trim;
    return $CamelCaseString if $CamelCaseString.contains: / \s | '/' /;
    $CamelCaseString.=subst: / ('_') (\w) /, {$1.uc}, :g;
}

sub to-kebab-case (Str $kebab-case-string is copy) {
    $kebab-case-string.=trim;
    return $kebab-case-string if $kebab-case-string.contains: / \s | '/' /;
    $kebab-case-string.=subst: / ('_') (\w) /, {'-' ~ $1.lc}, :g;
    $kebab-case-string.=subst: / <after <:Ll>> (<:Lu>|<:digit>+) /, {'-' ~ $0.lc}, :g;
    $kebab-case-string.=subst: / <after <:digit>> (<:Lu>) /, {'-' ~ $0.lc}, :g;
}

say   "{' ' x 30}to_snake_case";
printf "%33s ==> %s\n", $_, .&to_snake_case for @tests;
say "\n{' ' x 30}toCamelCase";
printf "%33s ==> %s\n", $_,   .&toCamelCase for @tests;
say "\n{' ' x 30}to-kabab-case";
printf "%33s ==> %s\n", $_, .&to-kebab-case for @tests;
