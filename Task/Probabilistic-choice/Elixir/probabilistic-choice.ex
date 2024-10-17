defmodule Probabilistic do
  @tries 1000000
  @probs [aleph:  1/5,
          beth:   1/6,
          gimel:  1/7,
          daleth: 1/8,
          he:     1/9,
          waw:    1/10,
          zayin:  1/11,
          heth:   1759/27720]

  def test do
    trials = for _ <- 1..@tries, do: get_choice(@probs, :rand.uniform)
    IO.puts "Item      Expected   Actual"
    fmt = " ~-8s ~.6f  ~.6f~n"
    Enum.each(@probs, fn {glyph,expected} ->
      actual = length(for ^glyph <- trials, do: glyph) / @tries
      :io.format fmt, [glyph, expected, actual]
    end)
  end

  defp get_choice([{glyph,_}], _), do: glyph
  defp get_choice([{glyph,prob}|_], ran) when ran < prob, do: glyph
  defp get_choice([{_,prob}|t], ran), do: get_choice(t, ran - prob)
end

Probabilistic.test
