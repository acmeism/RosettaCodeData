defmodule LucasLehmer do
  use Bitwise
  def test do
    for p <- 2..1300, p==2 or s(bsl(1,p)-1, p-1)==0, do: IO.write "M#{p} "
  end

  defp s(mp, 1), do: rem(4, mp)
  defp s(mp, n) do
    x = s(mp, n-1)
    rem(x*x-2, mp)
  end
end

LucasLehmer.test
