["snakeCase", "snake_case", "variable_10_case", "variable10Case", "ɛrgo rE tHis",
 "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "].each do |ident|
  print ident, " => "
  print ident.strip.gsub(/[ -]/, "_").camelcase, ", "
  puts  ident.strip.gsub(/[ -]/, "_").underscore
end
