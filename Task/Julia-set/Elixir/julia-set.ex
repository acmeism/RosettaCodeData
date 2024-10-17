defmodule Julia do
  def set(c_real, c_imag) do
    IO.puts "#{c_real}, #{c_imag}"
    vlist = Enum.take_every(-100..100, 4)
    hlist = Enum.take_every(-280..280, 4)
    Enum.each(vlist, fn v ->
      Enum.map(hlist, fn h ->
        loop(c_real, c_imag, h/200, v/100, "#", 0)
      end) |> IO.puts
    end)
  end

  defp loop(_, _, _, _, char, i) when i>=50, do: char
  defp loop(_, _, _, _, " ", _), do: " "
  defp loop(c_real, c_imag, x, y, char, i) do
    z_real = (x * x - y * y) + c_real
    z_imag = x * y * 2 + c_imag
    char = if z_real * z_real > 10000, do: " ", else: char
    loop(c_real, c_imag, z_real, z_imag, char, i+1)
  end
end

c_real = if r=Enum.at(System.argv, 0), do: Float.parse(r) |> elem(0), else: -0.8
c_imag = if c=Enum.at(System.argv, 1), do: Float.parse(c) |> elem(0), else: 0.156
Julia.set(c_real, c_imag)
