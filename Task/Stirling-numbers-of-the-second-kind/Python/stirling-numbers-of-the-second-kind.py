computed = {}

def sterling2(n, k):
	key = str(n) + "," + str(k)

	if key in computed.keys():
		return computed[key]
	if n == k == 0:
		return 1
	if (n > 0 and k == 0) or (n == 0 and k > 0):
		return 0
	if n == k:
		return 1
	if k > n:
		return 0
	result = k * sterling2(n - 1, k) + sterling2(n - 1, k - 1)
	computed[key] = result
	return result

print("Stirling numbers of the second kind:")
MAX = 12
print("n/k".ljust(10), end="")
for n in range(MAX + 1):
	print(str(n).rjust(10), end="")
print()
for n in range(MAX + 1):
	print(str(n).ljust(10), end="")
	for k in range(n + 1):
		print(str(sterling2(n, k)).rjust(10), end="")
	print()
print("The maximum value of S2(100, k) = ")
previous = 0
for k in range(1, 100 + 1):
	current = sterling2(100, k)
	if current > previous:
		previous = current
	else:
		print("{0}\n({1} digits, k = {2})\n".format(previous, len(str(previous)), k - 1))
		break
