open Yojson.Basic.Util

let s = "
{ \"name\": \"John Doe\",
  \"pages\": [
    { \"id\": 1,
      \"title\": \"The Art of Flipping Coins\",
      \"url\": \"http://example.com/398eb027/1\"
    },
    { \"id\": 2, \"deleted\": true },
    { \"id\": 3,
      \"title\": \"Artichoke Salad\",
      \"url\": \"http://example.com/398eb027/3\"
    },
    { \"id\": 4,
      \"title\": \"Flying Bananas\",
      \"url\": \"http://example.com/398eb027/4\"
    }
  ]
}"

let extract_titles json =
  [json]
    |> filter_member "pages"
    |> flatten
    |> filter_member "title"
    |> filter_string

let () =
  let json = Yojson.Basic.from_string s in
  List.iter print_endline (extract_titles json)
