if ["LANG", "LC_CTYPE", "LC_ALL"]
     |> Enum.map(&System.get_env/1)
     |> Enum.any?(&(&1 != nil and String.contains?(&1, "UTF")))
do
  IO.puts "This terminal supports Unicode: \x{25b3}"
else
  raise "This terminal does not support Unicode."
end
