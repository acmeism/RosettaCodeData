fib = fn f -> (
      fn x -> if x == 0, do: 0, else: (if x == 1, do: 1, else: f.(x - 1) + f.(x - 2))	end
	)
end

y = fn x -> (
    fn f -> f.(f)
  end).(
    fn g -> x.(fn z ->(g.(g)).(z) end)
  end)
end

IO.inspect y.(&(fib.(&1))).(40)
