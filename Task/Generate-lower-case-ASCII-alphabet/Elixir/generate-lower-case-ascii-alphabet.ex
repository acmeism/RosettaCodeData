iex(1)> Enum.to_list(?a .. ?z)
'abcdefghijklmnopqrstuvwxyz'
iex(2)> Enum.to_list(?a .. ?z) |> List.to_string
"abcdefghijklmnopqrstuvwxyz"
