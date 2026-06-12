do  -- find the derivatives of polynomials, given their coefficients

    -- returns the derivative polynomial of the polynomial defined by the array of coefficients p,
    --         where the coefficients are in order of increasing power of x
    local function polynomialDerivative( p )
        local result <const> = {}
        for i = 2, # p do
            result[ i - 1 ] = ( i - 1 ) * p[ i ]
        end
        return result
    end

    -- returns a string representation the polynomial defined by the coefficients in p
    local function polynomialToString( p )
        local first, result = true, ""
        for i = # p, 1, -1 do
            if p[ i ] ~= 0 then
                if not first then
                    result = result .. ( p[ i ] < 0 and " - " or " + " )
                else
                    if p[ i ] < 0 then result = result .. "-" end
                    first = false
                end
                local absCoefficient <const> = math.abs( p[ i ] )
                if i == 1 then result = result .. tostring( absCoefficient )
                else
                    if absCoefficient > 1 then result = result .. tostring( absCoefficient ) end
                    result = result .. "x"
                    if i > 2 then result = result .. "^" .. tostring( i - 1 ) end
               end
           end
        end
        if first then
            -- all coefficients were 0
            result = "0"
        end
        return result
    end

    -- task test cases
    local function test( p )
        io.write( string.format( "%24s", polynomialToString( p ) )
                , " -> ", polynomialToString( polynomialDerivative( p ) )
                , "\n"
                )
    end
    test( { 5 } )        test( { 4, -3 } )
    test( { -1, 6, 5 } ) test( { -4, 3, -2, 1 } ) test( { 1, 1, 0, -1, -1 } )
end
