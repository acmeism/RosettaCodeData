game_amend:{[Name]
  pfx:Name,", ",Name,", ";                                    / prefix
  n:lower Name;
  sfx:((n in "aeiouy")?1b)_n;                                 / suffix
  s:("bo-b";"Banana-fana fo-f";"Fee-fimo-m";"!";"");          / song template
  @[;0;pfx,] @[;3;Name,] @[;0 1 2;,[;sfx]] @[;where n[0]=last each s;-1_] s }

// test
1 "\n"sv raze game_ssr each ("Gary";"Earl";"Felix";"Stephen";"Ryan";"Jo");
