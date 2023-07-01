#!/bin/sh
# index.sh - create an inverted index

unset IFS
: ${INDEX:=index}

# Prohibit '\n' in filenames (because '\n' is
# the record separator for $INDEX/all.tab).
for file in "$@"; do
    # Use printf(1), not echo, because "$file" might start with
    # a hyphen and become an option to echo.
    test 0 -eq $(printf %s "$file" | wc -l) || {
        printf '%s\n' "$file: newline in filename" >&2
        exit 1
    }
done

# Make a new directory for the index, or else
# exit with the error message from mkdir(1).
mkdir "$INDEX" || exit $?

fi=1
for file in "$@"; do
    printf %s "Indexing $file." >&2

    # all.tab maps $fi => $file
    echo "$fi $file" >> "$INDEX/all.tab"

    # Use punctuation ([:punct:]) and whitespace (IFS)
    # to split tokens.
    ti=1
    tr -s '[:punct:]' ' ' < "$file" | while read line; do
        for token in $line; do
            # Index token by position ($fi, $ti). Ignore
            # error from mkdir(1) if directory exists.
            mkdir "$INDEX/$token" 2>/dev/null
            echo $ti >> "$INDEX/$token/$fi"
            : $((ti += 1))

            # Show progress. Print a dot per 1000 tokens.
            case "$ti" in
            *000)   printf .
            esac
        done
    done

    echo >&2
    : $((fi += 1))
done
