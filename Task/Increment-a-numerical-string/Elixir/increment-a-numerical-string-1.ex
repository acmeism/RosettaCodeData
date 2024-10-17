increment1 = fn n -> to_string(String.to_integer(n) + 1) end
# Or piped
increment2 = fn n -> n |> String.to_integer |> +1 |> to_string end

increment1.("1")
increment2.("100")
