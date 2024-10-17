defmodule Sort_by_OID do
  def numbers(list) do
    Enum.sort_by(list, fn oid ->
      String.split(oid, ".") |> Enum.map(&String.to_integer/1)
    end)
  end
end

~w[
  1.3.6.1.4.1.11.2.17.19.3.4.0.10
  1.3.6.1.4.1.11.2.17.5.2.0.79
  1.3.6.1.4.1.11.2.17.19.3.4.0.4
  1.3.6.1.4.1.11150.3.4.0.1
  1.3.6.1.4.1.11.2.17.19.3.4.0.1
  1.3.6.1.4.1.11150.3.4.0
]
|> Sort_by_OID.numbers
|> Enum.each(fn oid -> IO.puts oid end)
