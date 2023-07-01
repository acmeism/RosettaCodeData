type json item =
  < name    "Name": string;
    kingdom "Kingdom": string;
    phylum  "Phylum": string;
    class_  "Class": string;
    order   "Order": string;
    family  "Family": string;
    tribe   "Tribe": string
  >

let str = "
  {
    \"Name\":    \"camel\",
    \"Kingdom\": \"Animalia\",
    \"Phylum\":  \"Chordata\",
    \"Class\":   \"Mammalia\",
    \"Order\":   \"Artiodactyla\",
    \"Family\":  \"Camelidae\",
    \"Tribe\":   \"Camelini\"
  }"

let () =
  let j = Json_io.json_of_string str in
  print_endline (Json_io.string_of_json j);
