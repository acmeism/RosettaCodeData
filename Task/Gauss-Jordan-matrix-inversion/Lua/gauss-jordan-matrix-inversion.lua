do  -- Gauss Jordan Matrix inversion - translation of the EasyLang sample

    local function rref( m )
       local nrow, ncol, lead = # m, # m[1], 1
       for r = 1, nrow do
          if lead > ncol then return end
          local i = r
          while m[i][lead] == 0 do
             i = i + 1
             if i > nrow then
                i, lead = r, lead + 1
                if lead > ncol then return end
             end
          end
          m[i], m[r] = m[r], m[i]
          do
              local mrl = m[r][lead]
              for k = 1, ncol do m[r][k] = m[r][k] / mrl end
          end
          for i = 1, nrow do
             if i ~= r then
                local mil = m[i][lead]
                for k = 1, ncol do
                    m[i][k] = m[i][k] - ( mil * m[r][k] )
                end
             end
          end
          lead = lead + 1
       end
    end
    local function inverse( mat )
       local inv, ln, aug = {}, # mat, {}
       for i = 1, ln do
          if # mat[i] ~= ln then
             error( "not a square matrix" )
          end
          aug[ # aug + 1 ] = {}
          for j = 1, ln do aug[i][j] = mat[i][j] end
          for j = ln + 1, 2 * ln do aug[i][j] = 0 end
          aug[i][ln + i] = 1
       end
       rref( aug )
       for i = 1, ln do
          inv[ # inv + 1 ] = {}
          for j = ln + 1, 2 * ln do
             inv[i][ # inv[i] + 1 ] = aug[i][j]
          end
       end
       return inv
    end
    local function integerMatrix( m )
        for i = 1, # m do
            for j = 1, # m[ i ] do
                if math.type( m[ i ][ j ] ) ~= "integer" then return false end
            end
        end
        return true
    end
    local function printMatrix( m )
        local allInteger = integerMatrix( m )
        for i = 1, # m do
            io.write( i == 1 and "[ [" or "  [" )
            for j = 1, # m[ i ] do
                io.write( string.format( ( allInteger and " %9d" or " %9.6f" ), m[ i ][ j ] ) )
            end
            io.write( " ]\n" )
        end
        io.write( "]\n" )
    end
    local function testInverse( m )
        io.write( "Matrix:\n" )
        printMatrix( m )
        io.write( "Inverse:\n" )
        printMatrix( inverse( m ) )
        io.write( "\n" )
    end

    testInverse { { 1, 2, 3 }, { 4, 1, 6 }, { 7, 8, 9 } }
    testInverse { { 2, -1,  0 }, {-1,  2, -1 }, { 0, -1,  2 } }
    testInverse { { -1, -2, 3, 2 }, { -4, -1, 6, 2 }, {  7, -8, 9, 1 }, {  1, -2, 1, 3 } }
end
