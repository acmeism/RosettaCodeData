-- RMS of integer range a to b.
on rootMeanSquare(a, b)
	return ((b * (b + 1) * (2 * b + 1) - a * (a - 1) * (2 * a - 1)) / 6 / (b - a + 1)) ^ 0.5
end rootMeanSquare

rootMeanSquare(1, 10)
