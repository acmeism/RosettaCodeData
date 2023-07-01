defmodule Configuration_file do
  def read(file) do
    File.read!(file)
    |> String.split(~r/\n|\r\n|\r/, trim: true)
    |> Enum.reject(fn line -> String.starts_with?(line, ["#", ";"]) end)
    |> Enum.map(fn line ->
         case String.split(line, ~r/\s/, parts: 2) do
           [option]         -> {to_atom(option), true}
           [option, values] -> {to_atom(option), separate(values)}
         end
       end)
  end

  def task do
    defaults = [fullname: "Kalle", favouritefruit: "apple", needspeeling: false, seedsremoved: false]
    options = read("configuration_file") ++ defaults
    [:fullname, :favouritefruit, :needspeeling, :seedsremoved, :otherfamily]
    |> Enum.each(fn x ->
         values = options[x]
         if is_boolean(values) or length(values)==1 do
           IO.puts "#{x} = #{values}"
         else
           Enum.with_index(values) |> Enum.each(fn {value,i} ->
             IO.puts "#{x}(#{i+1}) = #{value}"
           end)
         end
       end)
  end

  defp to_atom(option), do: String.downcase(option) |> String.to_atom

  defp separate(values), do: String.split(values, ",") |> Enum.map(&String.strip/1)
end

Configuration_file.task
