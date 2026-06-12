def once_in_each_string:
  # convert each string to an array of the constituent characters
    map((explode | map([.]|implode)))
  # identify the singleton characters in each string; `keys` sorts the keys
    | map( bow(.[]) | with_entries(select(.value==1)) | keys)
    | intersections ;

["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]
| [once_in_each_string]
