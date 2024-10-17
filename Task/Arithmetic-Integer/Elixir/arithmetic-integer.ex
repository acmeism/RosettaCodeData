defmodule Arithmetic_Integer do
  # Function to remove line breaks and convert string to int
  defp get_int(msg) do
    IO.gets(msg) |> String.strip |> String.to_integer
  end

  def task do
    # Get user input
    a = get_int("Enter your first integer: ")
    b = get_int("Enter your second integer: ")

    IO.puts "Elixir Integer Arithmetic:\n"
    IO.puts "Sum:            #{a + b}"
    IO.puts "Difference:     #{a - b}"
    IO.puts "Product:        #{a * b}"
    IO.puts "True Division:  #{a / b}"                  # Float
    IO.puts "Division:       #{div(a,b)}"               # Truncated Towards 0
    IO.puts "Floor Division: #{Integer.floor_div(a,b)}" # floored integer division
    IO.puts "Remainder:      #{rem(a,b)}"               # Sign from first digit
    IO.puts "Modulo:         #{Integer.mod(a,b)}"       # modulo remainder (uses floored division)
    IO.puts "Exponent:       #{:math.pow(a,b)}"         # Float, using Erlang's :math
  end
end

Arithmetic_Integer.task
