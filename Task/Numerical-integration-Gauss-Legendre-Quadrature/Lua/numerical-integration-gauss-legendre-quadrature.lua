local order = 0

local legendreRoots = {}
local legendreWeights = {}

local function legendre(term, z)
    if (term == 0) then
        return 1
    elseif (term == 1) then
        return z
    else
        return ((2 * term - 1) * z * legendre(term - 1, z) - (term - 1) * legendre(term - 2, z)) / term
    end
end

local function legendreDerivative(term, z)
    if (term == 0) then
        return 0
    elseif (term == 1) then
        return 1
    else
        return ( term * ((z * legendre(term, z)) - legendre(term - 1, z))) / (z * z - 1)
    end
end

local function getLegendreRoots()
    local y, y1
	
    for index = 1, order do
        y = math.cos(math.pi * (index - 0.25) / (order + 0.5))
		
        repeat
            y1 = y
            y = y - (legendre(order, y) / legendreDerivative(order, y))
        until y == y1
		
        table.insert(legendreRoots, y)
    end
end

local function getLegendreWeights()
    for index = 1, order do
        local weight = 2 / ((1 - (legendreRoots[index]) ^ 2) * (legendreDerivative(order, legendreRoots[index])) ^ 2)
        table.insert(legendreWeights, weight)
    end
end

function gaussLegendreQuadrature(f, lowerLimit, upperLimit, n)
    order = n
	
    do
        getLegendreRoots()
        getLegendreWeights()
    end
	
    local c1 = (upperLimit - lowerLimit) / 2
    local c2 = (upperLimit + lowerLimit) / 2
    local sum = 0
	
    for i = 1, order do
        sum = sum + legendreWeights[i] * f(c1 * legendreRoots[i] + c2)
    end
	
    return c1 * sum
end

do
    print(gaussLegendreQuadrature(function(x) return math.exp(x) end, -3, 3, 5))
end
