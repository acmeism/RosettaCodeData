-- Initialisation
math.randomseed(os.time())
numList = {step = 0, sorted = 0}

-- Create list of n random values
function numList:build (n)
    self.values = {}
    for i = 1, n do self.values[i] = math.random(-100, 100) end
end

-- Return boolean indicating whether the list is in order
function numList:isSorted ()
    for i = 2, #self.values do
        if self.values[i] < self.values[i - 1] then return false end
    end
    print("Finished!")
    return true
end

-- Display list of numbers on one line
function numList:show ()
    if self.step == 0 then
        io.write("Initial state:\t")
    else
        io.write("After step " .. self.step .. ":\t")
    end
    for _, v in ipairs(self.values) do io.write(v .. " ") end
    print()
end

-- Reverse n values from the left
function numList:reverse (n)
    local flipped = {}
    for i, v in ipairs(self.values) do
        if i > n then
            flipped[i] = v
        else
            flipped[i] = self.values[n + 1 - i]
        end
    end
    self.values = flipped
end

-- Perform one flip of a pancake sort
function numList:pancake ()
    local maxPos = 1
    for i = 1, #self.values - self.sorted do
        if self.values[i] > self.values[maxPos] then maxPos = i end
    end
    if maxPos == 1 then
        numList:reverse(#self.values - self.sorted)
        self.sorted = self.sorted + 1
    else
        numList:reverse(maxPos)
    end
    self.step = self.step + 1
end

-- Main procedure
numList:build(10)
numList:show()
repeat
    numList:pancake()
    numList:show()
until numList:isSorted()
