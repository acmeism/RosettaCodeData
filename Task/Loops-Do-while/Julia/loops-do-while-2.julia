julia> @eval macro $(:do)(block, when::Symbol, condition)
           when ≠ :when && error("@do expected `when` got `$s`")
           quote
               let
                   $block
                   while $condition
                       $block
                   end
               end
           end |> esc
       end
@do (macro with 1 method)

julia> i = 0
0

julia> @do begin
           @show i
           i += 1
       end when i % 6 ≠ 0
i = 0
i = 1
i = 2
i = 3
i = 4
i = 5
