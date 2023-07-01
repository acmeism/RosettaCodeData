-- Matrix A[i] has dimension dims[i-1] x dims[i] for i = 1..n
local function MatrixChainOrder(dims)
    local m = {}
    local s = {}
    local n = #dims - 1;
    -- m[i,j] = Minimum number of scalar multiplications (i.e., cost)
    -- needed to compute the matrix A[i]A[i+1]...A[j] = A[i..j]
    -- The cost is zero when multiplying one matrix
    for i = 1,n do
        m[i] = {}
        m[i][i] = 0
        s[i] = {}
    end

    for len = 2,n do -- Subsequence lengths
        for i = 1,(n - len + 1) do
            local j = i + len - 1
            m[i][j] = math.maxinteger
            for k = i,(j - 1) do
                local cost = m[i][k] + m[k+1][j] + dims[i]*dims[k+1]*dims[j+1];
                if (cost < m[i][j]) then
                    m[i][j] = cost;
                    s[i][j] = k; --Index of the subsequence split that achieved minimal cost
                end
            end
        end
    end
    return m,s
end

local function printOptimalChainOrder(s)
    local function find_path(start,finish)
        local chainOrder = ""
        if (start == finish) then
            chainOrder = chainOrder .."A"..start
        else
            chainOrder = chainOrder .."(" ..
                         find_path(start,s[start][finish]) ..
                         find_path(s[start][finish]+1,finish) .. ")"
        end
        return chainOrder
    end
    print("Order : "..find_path(1,#s))
end

local dimsList = {{5, 6, 3, 1},{1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2},{1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10}}

for k,dim in ipairs(dimsList) do
    io.write("Dims  : [")
    for v=1,(#dim-1) do
        io.write(dim[v]..", ")
    end
    print(dim[#dim].."]")
    local m,s = MatrixChainOrder(dim)
    printOptimalChainOrder(s)
    print("Cost  : "..tostring(m[1][#s]).."\n")
end
