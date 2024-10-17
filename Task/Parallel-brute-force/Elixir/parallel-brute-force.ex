defmodule RosettacodeBruteForce do
  require Logger

  @spec start() :: :ok
  def start() do
    children = [
      {Task.Supervisor, name: Bf.TaskSupervisor}
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
    start_bf("1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad")
    start_bf("3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b")
    start_bf("74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f")
    :ok
  end

  @spec start_bf(String.t()) :: :ok
  def start_bf(target) do
    Enum.each(0..25, fn a ->
      Enum.each(0..25, fn b ->
        Task.Supervisor.async(Bf.TaskSupervisor, fn ->
          solve_bf(a, b, target)
        end)
      end)
    end)
    :ok
  end

  defp solve_bf(a, b, target) do
    Enum.each(0..25, fn x ->
      Enum.each(0..25, fn y ->
        Enum.each(0..25, fn z ->
          candidate = List.to_string([?a + a, ?a + b, ?a + x, ?a + y, ?a + z])
          if (check_hash?(candidate, target)) do
            Logger.info("SOLVED: #{candidate} = #{target}")
          end
        end)
      end)
    end)
    :ok
  end

  defp check_hash?(candidate, target) do
    target == :crypto.hash(:sha256, candidate)
    |> Base.encode16()
    |> String.downcase()
  end
end
