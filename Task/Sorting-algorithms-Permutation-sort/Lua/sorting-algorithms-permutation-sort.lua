-- Return an iterator to produce every permutation of list
function permute (list)
  local function perm (list, n)
    if n == 0 then coroutine.yield(list) end
    for i = 1, n do
      list[i], list[n] = list[n], list[i]
      perm(list, n - 1)
      list[i], list[n] = list[n], list[i]
    end
  end
  return coroutine.wrap(function() perm(list, #list) end)
end

-- Return true if table t is in ascending order or false if not
function inOrder (t)
  for pos = 2, #t do
    if t[pos] < t[pos - 1] then
      return false
    end
  end
  return true
end

-- Main procedure
local list = {2,3,1}                 --\   Written to match task pseudocode,
local nextPermutation = permute(list) --\  more idiomatic would be:
while not inOrder(list) do             --\
  list = nextPermutation()             --/   for p in permute(list) do
end                                   --/       stuffWith(p)
print(unpack(list))                  --/     end
