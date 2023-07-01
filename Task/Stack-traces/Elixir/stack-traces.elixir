defmodule Stack_traces do
  def main do
    {:ok, a} = outer
    IO.inspect a
  end

  defp outer do
    {:ok, a} = middle
    {:ok, a}
  end

  defp middle do
    {:ok, a} = inner
    {:ok, a}
  end

  defp inner do
    try do
      throw(42)
    catch 42 -> {:ok, :erlang.get_stacktrace}
    end
  end
end

Stack_traces.main
