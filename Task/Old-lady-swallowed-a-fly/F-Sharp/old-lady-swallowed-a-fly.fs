//Old lady swallowed a fly. Nigel Galloway: March 23rd., 2026
let an = [| "fly"; "spider"; "bird"; "cat"; "dog"; "pig"; "goat"; "cow"; "donkey" |]
let cm =
  [| "Quite absurd";
     "Fancy that";
     "What a hog";
     "Her mouth was so big";
     "She just opened her throat";
     "I don't know how";
     "It was rather wonky"; |]
let p = Printf.printfn
let h n =
  for i = n downto 1 do
    if i = 1 then
      p "That wriggled and jiggled and tickled inside her;";
    p "She swallowed the %s to catch the %s," an[i] an[i-1]
  done
let g n =
  if n >= 2 then p "%s, to swallow a %s;" cm[n-2] an[n]
let f n =
  p "There was an old lady who swallowed a %s," an[n]; g n; h n;
  p "But I don't know why she swallowed the fly,\nPerhaps she'll die!\n"
let () =
  for i = 0 to 8 do f i done;
  p "There was an old lady who swallowed a horse...\
     She's dead, of course!"
