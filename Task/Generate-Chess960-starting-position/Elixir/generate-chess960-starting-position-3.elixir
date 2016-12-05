defmodule Chess960 do
  @krn  ~w(NNRKR NRNKR NRKNR NRKRN RNNKR RNKNR RNKRN RKNNR RKNRN RKRNN)

  def start_position, do: start_position(:rand.uniform(960)-1)

  def start_position(id) do
    pos = List.duplicate(nil, 8)
    q = div(id, 4)
    r = rem(id, 4)
    pos = List.replace_at(pos, r * 2 + 1, "B")
    q = div(q, 4)
    r = rem(q, 4)
    pos = List.replace_at(pos, r * 2, "B")
    q = div(q, 6)
    r = rem(q, 6)
    i = Enum.reject(0..7, &Enum.at(pos,&1)) |> Enum.at(r)
    pos = List.replace_at(pos, i, "Q")
    krn = Enum.at(@krn, q) |> String.codepoints
    Enum.reject(0..7, &Enum.at(pos,&1))
    |> Enum.zip(krn)
    |> Enum.reduce(pos, fn {i,x},acc -> List.replace_at(acc,i,x) end)
    |> Enum.join
  end
end

IO.puts "Generate Start Position from ID number"
Enum.each([0,518,959], fn id ->
  :io.format "~3w : ~s~n", [id, Chess960.start_position(id)]
end)
IO.puts "\nGenerate random Start Position"
Enum.each(1..5, fn _ -> IO.puts Chess960.start_position end)
