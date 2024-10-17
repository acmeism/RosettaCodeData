let an =
  [| "fly"; "spider"; "bird"; "cat"; "dog"; "pig"; "goat"; "cow"; "donkey" |]

let cm =
  [| "Quite absurd";
     "Fancy that";
     "What a hog";
     "Her mouth was so big";
     "She just opened her throat";
     "I don't know how";
     "It was rather wonky"; |]

let p = Printf.printf

let h n =
  for i = n downto 1 do
    if i = 1 then
      p "That wriggled and jiggled and tickled inside her;\n";
    p "She swallowed the %s to catch the %s,\n" an.(i) an.(i-1)
  done

let g n =
  if n >= 2 then p "%s, to swallow a %s;\n" cm.(n-2) an.(n)

let f n =
  p "There was an old lady who swallowed a %s,\n" an.(n); g n; h n;
  p "But I don't know why she swallowed the fly,\nPerhaps she'll die!\n\n"

let () =
  for i = 0 to 8 do f i done;
  p "There was an old lady who swallowed a horse...\n\
     She's dead, of course!"
