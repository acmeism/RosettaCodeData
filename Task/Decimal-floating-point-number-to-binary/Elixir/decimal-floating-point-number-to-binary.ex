defmodule RC do
  def dec2bin(dec, precision\\16) do
    [int, df] = case String.trim(dec) |> String.split(".") do
      [int] -> [int, nil]
      [int, df] -> [int, df]
    end
    {sign, int} = if String.first(int)=="-", do: String.split_at(int, 1), else: {"", int}
    bin = sign <> (String.to_integer(int) |> Integer.to_string(2)) <> "."
    if df && String.to_integer(df)>0 do
      String.to_float("0."<>df) |> dec2bin(precision, bin)
    else
      bin <> "0"
    end
  end

  defp dec2bin(fp, digit, bin) when fp==0.0 or digit<=0, do: bin
  defp dec2bin(fp, digit, bin) do
    fp = fp * 2
    n = trunc(fp)
    dec2bin(fp-n, digit-1, bin<>Integer.to_string(n))
  end

  def bin2dec(bin) do
    [int, df] = case String.trim(bin) |> String.split(".") do
      [int] -> [int, nil]
      [int, df] -> [int, df]
    end
    {sign, int} = if String.first(int)=="-", do: String.split_at(int, 1), else: {"", int}
    dec = sign <> (String.to_integer(int, 2) |> Integer.to_string)
    dec <> if df && String.to_integer(df,2)>0 do
             1..String.length(df)
             |> Enum.reduce(String.to_integer(df, 2), fn _,acc -> acc / 2 end)
             |> to_string
             |> String.slice(1..-1)
           else
             ".0"
           end
  end
end

data = ~w[23.34375 11.90625 -23.34375 -11.90625]
Enum.each(data, fn dec ->
  bin  = RC.dec2bin(dec)
  dec2 = RC.bin2dec(bin)
  :io.format "~10s => ~12s =>~10s~n", [dec, bin, dec2]
end)

data = ~w[13 0.1 -5 -0.25]
Enum.each(data, fn dec ->
  bin  = RC.dec2bin(dec)
  dec2 = RC.bin2dec(bin)
  :io.format "~10s => ~18s =>~12s~n", [dec, bin, dec2]
end)
