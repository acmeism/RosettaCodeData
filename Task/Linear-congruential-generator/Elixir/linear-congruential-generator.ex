defmodule LCG do
  def ms_seed(seed) do
    Process.put(:ms_state, seed)
    ms_rand
    Process.put(:ms_seed, seed)
  end

  def ms_rand do
    state = Process.get(:ms_state)
    state2 = rem(214013 * state + 2531011, 2147483648)
    Process.put(:ms_state, state2)
    div(state, 65536)
  end

  def bsd_seed(seed) do
    Process.put(:bsd_state, seed)
    Process.put(:bsd_seed, seed)
  end

  def bsd_rand do
    state = Process.get(:bsd_state)
    state2 = rem(1103515245 * state + 12345, 2147483648)
    Process.put(:bsd_state, state2)
    state2
  end
end

Enum.each([0,1], fn i ->
  IO.puts "\nRandom seed: #{i}\n        BSD      MS"
  LCG.bsd_seed(i)
  LCG.ms_seed(i)
  Enum.each(1..10, fn _ ->
    :io.format "~11w~8w~n", [LCG.bsd_rand, LCG.ms_rand]
  end)
end)
