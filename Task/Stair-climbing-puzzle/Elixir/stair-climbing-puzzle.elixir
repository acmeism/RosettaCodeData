defmodule Stair_climbing do
  defp step, do: 1 == :rand.uniform(2)

  defp step_up(true), do: :ok
  defp step_up(false) do
    step_up(step)
    step_up(step)
  end

  def step_up, do: step_up(step)
end

IO.inspect Stair_climbing.step_up
