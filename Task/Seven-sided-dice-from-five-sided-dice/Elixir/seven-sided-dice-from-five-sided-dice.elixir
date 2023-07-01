defmodule Dice do
  def dice5, do: :rand.uniform( 5 )

  def dice7 do
    dice7_from_dice5
  end

  defp dice7_from_dice5 do
    d55 = 5*dice5 + dice5 - 6           # 0..24
    if d55 < 21, do: rem( d55, 7 ) + 1,
                 else: dice7_from_dice5
  end
end

fun5 = fn -> Dice.dice5 end
IO.inspect VerifyDistribution.naive( fun5, 1000000, 3 )
fun7 = fn -> Dice.dice7 end
IO.inspect VerifyDistribution.naive( fun7, 1000000, 3 )
