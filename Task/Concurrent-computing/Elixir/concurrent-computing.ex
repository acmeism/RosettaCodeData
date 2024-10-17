defmodule Concurrent do
  def computing(xs) do
    Enum.each(xs, fn x ->
      spawn(fn ->
        Process.sleep(:rand.uniform(1000))
        IO.puts x
      end)
    end)
    Process.sleep(1000)
  end
end

Concurrent.computing ["Enjoy", "Rosetta", "Code"]
