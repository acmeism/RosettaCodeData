f = fn n -> n + trunc(0.5 + :math.sqrt(n)) end

IO.inspect for n <- 1..22, do: f.(n)

n = 1_000_000
non_squares = for i <- 1..n, do: f.(i)
m = :math.sqrt(f.(n)) |> Float.ceil |> trunc
squares = for  i <- 1..m, do: i*i
case Enum.find_value(squares, fn i -> i in non_squares end) do
  nil -> IO.puts "No squares found below #{n}"
  val -> IO.puts "Error: number is a square: #{val}"
end
