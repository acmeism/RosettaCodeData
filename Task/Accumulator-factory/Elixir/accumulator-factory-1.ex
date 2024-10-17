defmodule AccumulatorFactory do
  def new(initial) do
    {:ok, pid} = Agent.start_link(fn() -> initial end)
    fn (a) ->
      Agent.get_and_update(pid, fn(old) -> {a + old, a + old} end)
    end
  end
end
