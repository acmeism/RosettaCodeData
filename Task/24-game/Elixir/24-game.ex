defmodule Game24 do
  def main do
    IO.puts "24 Game"
    play
  end

  defp play do
    IO.puts "Generating 4 digits..."
    digts = for _ <- 1..4, do: Enum.random(1..9)
    IO.puts "Your digits\t#{inspect digts, char_lists: :as_lists}"
    read_eval(digts)
    play
  end

  defp read_eval(digits) do
    exp = IO.gets("Your expression: ") |> String.strip
    if exp in ["","q"], do: exit(:normal)        # give up
    case {correct_nums(exp, digits), eval(exp)} do
      {:ok, x} when x==24 -> IO.puts "You Win!"
      {:ok, x} -> IO.puts "You Lose with #{inspect x}!"
      {err, _} -> IO.puts "The following numbers are wrong: #{inspect err, char_lists: :as_lists}"
    end
  end

  defp correct_nums(exp, digits) do
    nums = String.replace(exp, ~r/\D/, " ") |> String.split |> Enum.map(&String.to_integer &1)
    if length(nums)==4 and (nums--digits)==[], do: :ok, else: nums
  end

  defp eval(exp) do
    try do
      Code.eval_string(exp) |> elem(0)
    rescue
      e -> Exception.message(e)
    end
  end
end

Game24.main
