quibble() {
	# Here awk(1) is easier than sed(1).
	awk 'BEGIN {
		for (i = 1; i < ARGC - 2; i++) s = s ARGV[i] ", "
		i = ARGC - 2; if (i > 0) s = s ARGV[i] " and "
		i = ARGC - 1; if (i > 0) s = s ARGV[i]
		printf "{%s}\n", s
		exit 0
	}' "$@"
}

quibble
quibble ABC
quibble ABC DEF
quibble ABC DEF G H
