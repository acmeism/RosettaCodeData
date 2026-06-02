function Transpose( m )
    local res = {}

    for i = 1, #m[1] do
        res[i] = {}
        for j = 1, #m do
            res[i][j] = m[j][i]
        end
    end

    return res
end

-- a test for Transpose(m)
mat = { { 1, 2, 3 }, { 4, 5, 6 } }
erg = Transpose( mat )
for i = 1, #erg do
    print( table.concat( erg[i], "  " ) )
end
