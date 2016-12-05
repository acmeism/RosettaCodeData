function partition (list, left, right, pivotIndex)
    local pivotValue = list[pivotIndex]
    list[pivotIndex], list[right] = list[right], list[pivotIndex]
    local storeIndex = left
    for i = left, right do
        if list[i] < pivotValue then
            list[storeIndex], list[i] = list[i], list[storeIndex]
            storeIndex = storeIndex + 1
        end
    end
    list[right], list[storeIndex] = list[storeIndex], list[right]
    return storeIndex
end

function quickSelect (list, left, right, n)
    local pivotIndex
    while 1 do
        if left == right then return list[left] end
        pivotIndex = math.random(left, right)
        pivotIndex = partition(list, left, right, pivotIndex)
        if n == pivotIndex then
            return list[n]
        elseif n < pivotIndex then
            right = pivotIndex - 1
        else
            left = pivotIndex + 1
        end
    end
end

math.randomseed(os.time())
local vec = {9, 8, 7, 6, 5, 0, 1, 2, 3, 4}
for i = 1, 10 do print(i, quickSelect(vec, 1, #vec, i) .. " ") end
