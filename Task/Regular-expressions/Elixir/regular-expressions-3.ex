str1 = ~r/a/ |> Regex.replace(str,"another")
str2 = str1 |> String.replace(~r/another/,"even another")
