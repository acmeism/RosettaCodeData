function generateposition()
    # Placeholder knights
    rank = ['♘', '♘', '♘', '♘', '♘', '♘', '♘', '♘']
    lrank = length(rank)

    # Check if a space is available
    isfree(x::Int) = rank[x] == '♘'

    # Place the King
    rank[indking = rand(2:lrank-1)] = '♔'

    # Place rooks
    rank[indrook = rand(filter(isfree, 1:lrank))] = '♖'
    if indrook > indking
        rank[rand(filter(isfree, 1:indking-1))] = '♖'
    else
        rank[rand(filter(isfree, indking+1:lrank))] = '♖'
    end

    # Place bishops
    rank[indbish = rand(filter(isfree, 1:8))] = '♗'
    pbish = filter(iseven(indbish) ? isodd : iseven, 1:lrank)
    rank[rand(filter(isfree, pbish))] = '♗'

    # Place queen
    rank[rand(filter(isfree, 1:lrank))] = '♕'
    return rank
end

@show generateposition()
