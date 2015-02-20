n = 5
dx, dy = [0, 1, 0, -1], [1, 0, -1, 0]
x, y, c = 0, -1, 1
m = [[0 for i in range(n)] for j in range(n)]
for i in range(n + n - 1):
	for j in range((n + n - i) // 2):
		x += dx[i % 4]
		y += dy[i % 4]
		m[x][y] = c
		c += 1
print('\n'.join([' '.join([str(v) for v in r]) for r in m]))
