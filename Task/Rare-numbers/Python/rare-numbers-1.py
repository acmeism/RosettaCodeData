# rare.py
# find rare numbers
# by kHz

from math import floor, sqrt
from datetime import datetime

def main():
	start = datetime.now()
	for i in xrange(1, 10 ** 11):
		if rare(i):
			print "found a rare:", i
	end = datetime.now()
	print "time elapsed:", end - start

def is_square(n):
	s = floor(sqrt(n + 0.5))
	return s * s == n

def reverse(n):
	return int(str(n)[::-1])

def is_palindrome(n):
	return n == reverse(n)

def rare(n):
	r = reverse(n)
	return (
		not is_palindrome(n) and
		n > r and
		is_square(n+r) and is_square(n-r)
	)

if __name__ == '__main__':
	main()
