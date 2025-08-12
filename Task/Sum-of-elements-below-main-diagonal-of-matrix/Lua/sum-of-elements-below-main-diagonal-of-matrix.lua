do  -- sum the elements below the main diagonal of a matrix

    -- returns the sum of the elements below the main diagonal
    --         of m, m must be a square matrix
    local function lowerSum( m )
        local sum = 0
        for r = 2, # m do
            if # m[ r ] ~= # m then
                error( "Matrix is not square" )
            else
                for c = 1, r - 1 do
                    sum = sum + m[ r ][ c ]
                end
            end
        end
        return sum
    end

    -- task test case
    print( lowerSum{ {  1,  3,  7,  8, 10 }
                   , {  2,  4, 16, 14,  4 }
                   , {  3,  1,  9, 18, 11 }
                   , { 12, 14, 17, 18, 20 }
                   , {  7,  1,  3,  9,  5 }
                   }
         )
end
