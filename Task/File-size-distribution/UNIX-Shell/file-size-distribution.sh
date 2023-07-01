#!/bin/sh
set -eu

tabs -8
if [ ${GNU:-} ]
then
    find -- "${1:-.}" -type f -exec du -b -- {} +
else
    # Use a subshell to remove the last "total" line per each ARG_MAX
    find -- "${1:-.}" -type f -exec sh -c 'wc -c -- "$@" | sed \$d' argv0 {} +
fi | awk -vOFS='\t' '
    BEGIN {split("KB MB GB TB PB", u); u[0] = "B"}
    {
        ++hist[$1 ? length($1) - 1 : -1]
        total += $1
    }
    END {
        max = -2
        for (i in hist)
            max = (i > max ? i : max)

        print "From", "To", "Count\n"
        for (i = -1; i <= max; ++i)
        {
            if (i in hist)
            {
                if (i == -1)
                    print "0B", "0B", hist[i]
                else
                    print 10 ** (i       % 3) u[int(i       / 3)],
                          10 ** ((i + 1) % 3) u[int((i + 1) / 3)],
                          hist[i]
            }
        }
        l = length(total) - 1
        printf "\nTotal: %.1f %s in %d files\n",
            total / (10 ** l), u[int(l / 3)], NR
    }'
