defmodule ObjectCall do
  def new() do
    spawn_link(fn -> loop end)
  end

  defp loop do
    receive do
      {:concat, {caller, [str1, str2]}} ->
        result = str1 <> str2
        send caller, {:ok, result}
        loop
    end
  end

  def concat(obj, str1, str2) do
    send obj, {:concat, {self(), [str1, str2]}}

    receive do
      {:ok, result} ->
        result
    end
  end
end

obj = ObjectCall.new()

IO.puts(obj |> ObjectCall.concat("Hello ", "World!"))
