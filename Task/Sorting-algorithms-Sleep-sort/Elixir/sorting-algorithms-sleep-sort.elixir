defmodule Sort do
  def sleep_sort(args) do
    Enum.each(args, fn(arg) -> Process.send_after(self, arg, 5 * arg) end)
    loop(length(args))
  end

  defp loop(0), do: :ok
  defp loop(n) do
    receive do
        num -> IO.puts num
               loop(n - 1)
    end
  end
end

Sort.sleep_sort [2, 4, 8, 12, 35, 2, 12, 1]
