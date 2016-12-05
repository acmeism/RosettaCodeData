julia> macro do_while(condition, block)
           quote
               let
                   $block
                   while $condition
                       $block
                   end
               end
           end |> esc
       end
@do_while (macro with 1 method)

julia> i = 0
0

julia> @do_while i % 6 ≠ 0 begin
           @show i
           i += 1
       end
i = 0
i = 1
i = 2
i = 3
i = 4
i = 5
