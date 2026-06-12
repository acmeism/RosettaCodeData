--[[
This script implements the Quine-McCluskey algorithm for minimising boolean
functions. It takes a list of minterm indices and the number of variables, and
returns a simplified sum-of-products expression. In addition to finding
essential prime implicants, it now searches (by brute force) for a minimal set
of non‐essential prime implicants to cover any leftover minterms.

Key components:

1. Binary string manipulation and conversion
2. Prime implicant generation through iterative merging
3. Prime implicant chart creation
4. Essential prime implicant identification
5. Brute‐force covering for remaining minterms (Petrick's method simplified)
6. Final expression formatting
--]]

-- Helper function: convert a binary string (e.g. "1010") into its numeric
-- value.
-- @param binStr: binary string containing only "0"s and "1"s
-- @return: numeric value of the binary string
-- @throws: error if string contains invalid binary digits
local function binaryToNumber(binStr)
    local result = 0
    for i = 1, #binStr do
        local c = binStr:sub(i, i)
        if c ~= "0" and c ~= "1" then
            error("Invalid binary digit: "..c)
        end
        result = result * 2 + (c == "1" and 1 or 0)
    end
    return result
end

-- Helper function: check if a list "t" contains value "val".
-- @param t: table to search
-- @param val: value to find
-- @return: boolean indicating whether value was found
local function tableContains(t, val)
    for _, v in ipairs(t) do
        if val == v then
            return true
        end
    end
    return false
end

-- Merge two binary implicants of equal length (possibly containing "-").
-- Wherever the bits differ, replace with "-". Otherwise, keep the bit.
-- Assumes that existing dashes already align (no position where one is "-" and
-- other is "0"/"1").
-- @param m1: first implicant string
-- @param m2: second implicant string
-- @return: merged implicant string
local function mergeMinterms(m1, m2)
    local length = #m1
    local merged = {}

    for i = 1, length do
        local b1 = m1:sub(i, i)
        local b2 = m2:sub(i, i)

        if b1 ~= b2 then
            table.insert(merged, "-")
        else
            table.insert(merged, b1)
        end
    end

    return table.concat(merged)
end

-- Check that any dash in one implicant aligns only with a dash in the other.
-- If one string has "-" and the other has "0"/"1" at the same position, return
-- false.
-- @param m1: first implicant string
-- @param m2: second implicant string
-- @return: boolean indicating if dashes are properly aligned
local function areDashesAligned(m1, m2)
    local length = #m1
    for i = 1, length do
        local b1 = m1:sub(i, i)
        local b2 = m2:sub(i, i)

        if (b1 == "-" and b2 ~= "-") or (b2 == "-" and b1 ~= "-") then
            return false
        end
    end
    return true
end

-- Determine if two implicants differ in exactly one bit (treating "-" as "0").
-- Replace "-" with "0", convert to numbers, XOR, and check if result is a power
-- of two.
-- @param m1: first implicant string
-- @param m2: second implicant string
-- @return: boolean indicating if implicants differ by exactly one bit
local function checkMintermDifference(m1, m2)
    local i1 = binaryToNumber(m1:gsub("-", "0"))
    local i2 = binaryToNumber(m2:gsub("-", "0"))
    local x = i1 ~ i2
    return x ~= 0 and (x & (x - 1)) == 0
end

-- Recursively generate all prime implicants from a list of implicants
-- (binary strings with possible '-').
-- In each pass, attempt to merge every pair that can be merged. Any implicant
-- not merged in that pass becomes prime.
-- Collect newly merged implicants and recur until no merges occur.
-- @param minterms: sorted list of binary strings (may contain "-")
-- @return: sorted list of prime implicants
local function getPrimeImplicants(minterms)
    -- "minterms" is a sorted list of strings (e.g., { "0001", "0011", "0111", ... }
    -- or containing "-").
    local length = #minterms
    local mergedFlags = {}
    for i = 1, length do
        mergedFlags[i] = false
    end
    local mergesCount = 0

    local newImplicants = {}
    local newLookup = {}

    -- Try to merge all possible pairs of implicants
    for i = 1, length do
        for j = i + 1, length do
            local m1 = minterms[i]
            local m2 = minterms[j]

            if areDashesAligned(m1, m2) and checkMintermDifference(m1, m2) then
                local merged = mergeMinterms(m1, m2)
                if not newLookup[merged] then
                    table.insert(newImplicants, merged)
                    newLookup[merged] = true
                end
                mergesCount = mergesCount + 1
                mergedFlags[i] = true
                mergedFlags[j] = true
            end
        end
    end

    -- Collect implicants that couldn't be merged in this round
    local primeThisRound = {}
    for idx = 1, length do
        if not mergedFlags[idx] then
            local m = minterms[idx]
            if not newLookup[m] then
                table.insert(primeThisRound, m)
                newLookup[m] = true
            end
        end
    end

    -- Base case: no more merges possible
    if mergesCount == 0 then
        table.sort(primeThisRound)
        return primeThisRound
    end

    -- Combine new implicants with primes from this round and recurse
    local combined = {}
    for _, v in ipairs(newImplicants) do
        if not tableContains(combined, v) then
            table.insert(combined, v)
        end
    end
    for _, v in ipairs(primeThisRound) do
        if not tableContains(combined, v) then
            table.insert(combined, v)
        end
    end
    table.sort(combined)

    return getPrimeImplicants(combined)
end

-- Convert a prime implicant string (with "-") into a Lua pattern that matches
-- any binary string of same length.
-- Replace each "-" with "[01]". Surround with "^" and "$" to match entire string.
-- @param implicant: string with "0", "1", or "-"
-- @return: Lua pattern string
local function convertToPattern(implicant)
    local pattern = {"^"}

    for i = 1, #implicant do
        local c = implicant:sub(i, i)
        if c == "-" then
            table.insert(pattern, "[01]")
        else
            table.insert(pattern, c)
        end
    end

    table.insert(pattern, "$")
    return table.concat(pattern)
end

-- Build the prime implicant chart: a table mapping implicant -> coverage
-- string ("0"/"1" per minterm).
-- `primeImplicants` is a list of strings (with "-"), `minterms` is the original
-- list of binary strings.
-- For each implicant, we test it against every minterm using "string.match"
-- with the generated pattern.
-- @param minterms: original list of binary strings
-- @return: table mapping implicants to coverage strings ("0"/"1" per minterm)
local function createPrimeImplicantChart(primeImplicants, minterms)
    local chart = {}
    for _, pi in ipairs(primeImplicants) do
        chart[pi] = ""
    end

    local patterns = {}
    for _, pi in ipairs(primeImplicants) do
        patterns[pi] = convertToPattern(pi)
    end

    for _, pi in ipairs(primeImplicants) do
        local pat = patterns[pi]
        local coverage = {}

        for _, m in ipairs(minterms) do
            if m:match(pat) then
                table.insert(coverage, "1")
            else
                table.insert(coverage, "0")
            end
        end

        chart[pi] = table.concat(coverage)
    end

    return chart
end

-- Identify essential prime implicants from the prime implicant chart.
-- If a minterm (column) is covered by exactly one implicant (i.e., that
-- coverage string has a single "1" in that column), that implicant is
-- essential. Return a sorted list of essential implicant strings.
-- @param chart: prime implicant chart from "createPrimeImplicantChart"
-- @param minterms: original list of binary strings
-- @return: sorted list of essential implicant strings
local function getEssentialPrimeImplicants(chart, minterms)
    local essentialsLookup = {}
    local primeImplicants = {}

    for pi, _ in pairs(chart) do
        table.insert(primeImplicants, pi)
    end
    table.sort(primeImplicants)

    local numMinterms = #minterms

    -- Check each minterm (column) for single coverage
    for col = 1, numMinterms do
        local covering = {}

        for _, pi in ipairs(primeImplicants) do
            local covStr = chart[pi]
            if covStr:sub(col, col) == "1" then
                table.insert(covering, pi)
            end
        end
        if #covering == 1 then
            essentialsLookup[covering[1]] = true
        end
    end

    local essentials = {}
    for pi, _ in pairs(essentialsLookup) do
        table.insert(essentials, pi)
    end
    table.sort(essentials)

    return essentials
end

-- Convert a prime implicant like "01-1" into a human-readable product term.
-- `varNames` is a list like { "A", "B", "C", ... }. A "1" means include var,
-- "0" means include var', "-" means drop var.
-- @param implicant: string with "0", "1", or "-"
-- @param varNames: list of variable names (e.g., {"A", "B", "C", "D"})
-- @return: product term string (e.g., "A'BC'D")
local function implicantToExpression(implicant, varNames)
    local terms = {}

    for i = 1, #implicant do
        local bit = implicant:sub(i, i)
        local var = varNames[i]
        if bit == "1" then
            table.insert(terms, var)
        elseif bit == "0" then
            table.insert(terms, var.."'")
        end
    end
    if #terms == 0 then
        return "1"
    end

    return table.concat(terms, "")
end

-- Find a minimal‐size subset of "nonEssentials" that covers all
-- "remainingMinterms".
-- "coverageMap" maps each PI -> list of numeric minterms it covers.
-- Uses a simple brute‐force search: tries combinations in increasing size until
-- one covers everything. Returns a sorted array of chosen PI strings.
-- @param nonEssentials: string[] -- array of prime implicant strings (e.g., "0-1-")
-- @param remainingMinterms: number[] -- array of minterm indices (integers)
-- @param coverageMap: table<string, number[]> -- map from prime implicant string
--                                                to list of minterm indices it covers
-- @return: string[] -- sorted array of chosen prime implicants covering all remaining
--                      minterms
local function findMinimalCover(nonEssentials, remainingMinterms, coverageMap)
    -- Convert remainingMinterms to a lookup for fast check:
    local toCover = {}
    for _, m in ipairs(remainingMinterms) do
        toCover[m] = true
    end

    local bestSolution = nil
    local bestCount = math.huge

    -- Utility: check if a candidate set of PIs covers all needed minterms:
    local function coversAll(candidateSet)
        local coveredLookup = {}

        for _, pi in ipairs(candidateSet) do
            for _, m in ipairs(coverageMap[pi]) do
                coveredLookup[m] = true
            end
        end

        -- Make sure every minterm in "remainingMinterms" is covered:
        for _, m in ipairs(remainingMinterms) do
            if not coveredLookup[m] then
                return false
            end
        end

        return true
    end

    -- Generate combinations of size k recursively:
    local function combine(startIdx, k, current)
        if #current == k then
            if coversAll(current) then
                -- Found a valid cover of size k, record and stop early
                bestSolution = {table.unpack(current)}
                bestCount = k
                return true
            end
            return false
        end
        for i = startIdx, #nonEssentials do
            if (#current + 1) <= k then
                table.insert(current, nonEssentials[i])
                local found = combine(i+1, k, current)
                table.remove(current)  -- backtrack
                if found then
                    return true
                end
            end
        end
        return false
    end

    -- Try combination sizes from 1 upward:
    for k = 1, #nonEssentials do
        if combine(1, k, {}) then
            break
        end
    end

    if bestSolution then
        table.sort(bestSolution)
    else
        bestSolution = {}
    end

    return bestSolution
end

-- Main Quine-McCluskey function.
-- mintermIndices: list of integer minterms, e.g. {0,1,2,5,6,7,8,9,10,14}
-- numVars: number of boolean variables, e.g. 4 for A, B, C, D
-- Returns a string representing the simplified sum-of-products expression.
local function quineMcCluskey(mintermIndices, numVars)
    -- Convert minterm indices to binary strings
    local mintermsBin = {}

    for _, m in ipairs(mintermIndices) do
        local bin = ""
        for i = numVars - 1, 0, -1 do
            local bit = (m >> i) & 1
            bin = bin .. (bit == 1 and "1" or "0")
        end
        table.insert(mintermsBin, bin)
    end
    table.sort(mintermsBin)

    -- Keep a map from binary string -> numeric minterm for easy lookup later
    local binToNum = {}
    for _, bin in ipairs(mintermsBin) do
        binToNum[bin] = binaryToNumber(bin)
    end

    -- Generate all prime implicants
    local primeImplicants = getPrimeImplicants(mintermsBin)
    -- Create coverage chart and find essential primes
    local chart = createPrimeImplicantChart(primeImplicants, mintermsBin)
    local essentialPIs = getEssentialPrimeImplicants(chart, mintermsBin)

    -- First, build a set of all numeric minterms that each essential covers:
    local coveredByEssential = {}
    for _, pi in ipairs(essentialPIs) do
        local pat = convertToPattern(pi)
        for _, bin in ipairs(mintermsBin) do
            if bin:match(pat) then
                coveredByEssential[binToNum[bin]] = true
            end
        end
    end

    -- Build a list of remaining minterms (numeric) that are not yet covered:
    local remainingMinterms = {}
    for _, m in ipairs(mintermIndices) do
        if not coveredByEssential[m] then
            table.insert(remainingMinterms, m)
        end
    end
    table.sort(remainingMinterms)

    -- If some minterms remain, find a minimal set of non‐essential PIs to cover them
    local finalPIs = {}  -- will contain all chosen PIs (essential + chosen non‐essential)
    for _, pi in ipairs(essentialPIs) do
        table.insert(finalPIs, pi)
    end

    if #remainingMinterms > 0 then
        -- Build a list of non‐essential prime implicants:
        local nonEssentials = {}
        do
            local essSet = {}

            for _, e in ipairs(essentialPIs) do
                essSet[e] = true
            end

            for _, pi in ipairs(primeImplicants) do
                if not essSet[pi] then
                    table.insert(nonEssentials, pi)
                end
            end
        end
        table.sort(nonEssentials)

        -- Build "coverageMap": PI -> list of numeric minterms it covers (intersect with
        -- remaining)
        local coverageMap = {}

        for _, pi in ipairs(nonEssentials) do
            local coveredList = {}
            local pat = convertToPattern(pi)

            for _, bin in ipairs(mintermsBin) do
                local num = binToNum[bin]
                if bin:match(pat) and tableContains(remainingMinterms, num) then
                    table.insert(coveredList, num)
                end
            end

            coverageMap[pi] = coveredList
        end

        -- Find a minimal subset of nonEssentials that covers all "remainingMinterms"
        local chosenNonEssentials = findMinimalCover(nonEssentials, remainingMinterms, coverageMap)
        for _, pi in ipairs(chosenNonEssentials) do
            table.insert(finalPIs, pi)
        end
    end

    local varNames = {}
    for i = 1, numVars do
        varNames[i] = string.char(("A"):byte() + i - 1)
    end

    local expressionTerms = {}
    for _, pi in ipairs(finalPIs) do
        table.insert(expressionTerms, implicantToExpression(pi, varNames))
    end

    if #expressionTerms == 0 then
        return "0"
    end

    return table.concat(expressionTerms, " + ")
end

-- Example usage
local sampleMinterms = {0, 1, 2, 5, 6, 7, 8, 9, 10, 14}
local numVariables = 4

local simplifiedExpr = quineMcCluskey(sampleMinterms, numVariables)
print("Simplified expression:", simplifiedExpr)
