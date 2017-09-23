def prompt_search:
  "Enter a string or an array of strings to search for, quoting each string, or 0 to exit:",
  ( (input | if type == "array" then . elif type == "string" then [.]
             else empty
             end) as $in
    | search($in), prompt_search ) ;

$in | inverted_index | prompt_search
