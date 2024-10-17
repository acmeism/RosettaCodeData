defmodule TopRank do
  def per_groupe(data, n) do
    String.split(data, ~r/(\n|\r\n|\r)/, trim: true)
    |> Enum.drop(1)
    |> Enum.map(fn person -> String.split(person,",") end)
    |> Enum.group_by(fn person -> department(person) end)
    |> Enum.each(fn {department,group} ->
         IO.puts "Department: #{department}"
         Enum.sort_by(group, fn person -> -salary(person) end)
         |> Enum.take(n)
         |> Enum.each(fn person -> IO.puts str_format(person) end)
       end)
  end

  defp salary([_,_,x,_]), do: String.to_integer(x)
  defp department([_,_,_,x]), do: x
  defp str_format([a,b,c,_]), do: "  #{a} - #{b} - #{c} annual salary"
end

data = """
Employee Name,Employee ID,Salary,Department
Tyler Bennett,E10297,32000,D101
John Rappl,E21437,47000,D050
George Woltman,E00127,53500,D101
Adam Smith,E63535,18000,D202
Claire Buckman,E39876,27800,D202
David McClellan,E04242,41500,D101
Rich Holcomb,E01234,49500,D202
Nathan Adams,E41298,21900,D050
Richard Potter,E43128,15900,D101
David Motsinger,E27002,19250,D202
Tim Sampair,E03033,27000,D101
Kim Arlich,E10001,57000,D190
Timothy Grove,E16398,29900,D190
"""
TopRank.per_groupe(data, 3)
