reverse(Bin) ->
    Size = size(Bin)*8,
    <<T:Size/integer-little>> = Bin,
    <<T:Size/integer-big>>.
