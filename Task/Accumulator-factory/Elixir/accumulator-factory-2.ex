ExUnit.start

defmodule AccumulatorFactoryTest do
  use ExUnit.Case

  test "Accumulator basic function" do
    foo = AccumulatorFactory.new(1)
    foo.(5)
    bar = AccumulatorFactory.new(3)
    assert bar.(4) == 7
    assert foo.(2.3) == 8.3
  end
end
