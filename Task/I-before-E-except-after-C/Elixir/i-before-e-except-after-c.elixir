defmodule RC do
  def task(path) do
    plausibility_ratio = 2
    rules = [ {"I before E when not preceded by C:", "ie", "ei"},
              {"E before I when preceded by C:", "cei", "cie"} ]
    regex = ~r/ie|ei|cie|cei/
    counter = File.read!(path) |> countup(regex)
    Enum.all?(rules, fn {str, x, y} ->
      nx = counter[x]
      ny = counter[y]
      ratio = nx / ny
      plausibility = if ratio > plausibility_ratio, do: "Plausible", else: "Implausible"
      IO.puts str
      IO.puts "  #{x}: #{nx}; #{y}: #{ny}; Ratio: #{Float.round(ratio,3)}: #{plausibility}"
      ratio > plausibility_ratio
    end)
  end

  def countup(binary, regex) do
    String.split(binary)
    |> Enum.reduce(Map.new, fn word,acc ->
         if match = Regex.run(regex, word),
             do: Dict.update(acc, hd(match), 1, &(&1+1)), else: acc
       end)
  end
end

path = hd(System.argv)
IO.inspect RC.task(path)
