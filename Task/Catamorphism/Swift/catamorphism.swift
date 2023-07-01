let nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

print(nums.reduce(0, +))
print(nums.reduce(1, *))
print(nums.reduce("", { $0 + String($1) }))
