#!/bin/awk -f
# use as: awk -f middle_three_digits.awk

BEGIN {
	n = split("123 12345 1234567 987654321 10001 -10001 -123 -100 100 -12345 1 2 -1 -10 2002 -2002 0", arr)

	for (i=1; i<=n; i++) {
		if (arr[i] !~ /^-?[0-9]+$/) {
			printf("%10s : invalid input: not a number\n", arr[i])
			continue
		}

		num = arr[i]<0 ? -arr[i]:arr[i]
		len = length(num)

		if (len < 3) {
			printf("%10s : invalid input: too few digits\n", arr[i])
			continue
		}

		if (len % 2 == 0) {
			printf("%10s : invalid input: even number of digits\n", arr[i])
			continue
		}

		printf("%10s : %s\n", arr[i], substr(num, len/2, 3))
	}
}
