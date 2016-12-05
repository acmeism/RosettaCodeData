defmodule VerifyDistribution do
  def naive( generator, times, delta_percent ) do
    dict = Enum.reduce( List.duplicate(generator, times), Map.new, &update_counter/2 )
    values = Map.values(dict)
    average = Enum.sum( values ) / map_size( dict )
    delta = average * (delta_percent / 100)
    fun = fn {_key, value} -> abs(value - average) > delta end
    too_large_dict = Enum.filter( dict, fun )
    return( length(too_large_dict), too_large_dict, average, delta_percent )
  end

  def return( 0, _too_large_dict, _average, _delta ), do: :ok
  def return( _n, too_large_dict, average, delta ) do
    {:error, {too_large_dict, :failed_expected_average, average, 'with_delta_%', delta}}
  end

  def update_counter( fun, dict ), do: Map.update( dict, fun.(), 1, &(&1+1) )
end

fun = fn -> Dice.dice7 end
IO.inspect VerifyDistribution.naive( fun, 100000, 3 )
IO.inspect VerifyDistribution.naive( fun, 100, 3 )
