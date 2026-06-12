""" https://rosettacode.org/mw/index.php?title=Round-robin_tournament_schedule """

function schurig(N, verbose = true)
    """ Taken from https://en.wikipedia.org/wiki/Round-robin_tournament
        #Original_construction_of_pairing_tables_by_Richard_Schurig_(1886) """
    nrows = isodd(N) ? N : N - 1
    ncols = (N + 1) ÷ 2
    players = mod1.(reshape(collect(1:nrows*ncols), ncols, nrows)', nrows)
    opponents = zero(players)
    table = [(0, 0) for _ in 1:nrows, _ in 1:ncols]
    for i in 1:nrows
        oldrow = i == nrows ? 1 : i + 1
        verbose && print("\n", rpad("Round $i:", 10))
        for j in 1:ncols
            oldcol = ncols - j + 1
            opponents[i, j] = players[oldrow, oldcol]
            j == 1 && (opponents[i, j] = iseven(N) ? N : 0)
            table[i, j] = (sort([players[i, j], opponents[i, j]])...,)
            if verbose
                s1, s2 = string.(table[i, j])
                print(rpad("($(s1 == "0" ? "Bye" : s1) - $s2)", 10))
            end
        end
    end
    return table
end

print("Schurig table for round robin with 12 players:")
schurig(12)
print("\n\nSchurig table for round robin with 7 players:")
schurig(7)
