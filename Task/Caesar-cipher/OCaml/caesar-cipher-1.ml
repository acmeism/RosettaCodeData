let islower c =
  c >= 'a' && c <= 'z'

let isupper c =
  c >= 'A' && c <= 'Z'

let rot x str =
  let upchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  and lowchars = "abcdefghijklmnopqrstuvwxyz" in
  let rec decal x =
    if x < 0 then decal (x + 26) else x
  in
  let x = (decal x) mod 26 in
  let decal_up = x - (int_of_char 'A')
  and decal_low = x - (int_of_char 'a') in
  String.map (fun c ->
    if islower c then
      let j = ((int_of_char c) + decal_low) mod 26 in
      lowchars.[j]
    else if isupper c then
      let j = ((int_of_char c) + decal_up) mod 26 in
      upchars.[j]
    else
      c
  ) str
