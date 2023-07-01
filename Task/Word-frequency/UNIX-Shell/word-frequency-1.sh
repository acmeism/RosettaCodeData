#!/bin/sh
<"$1" tr -cs A-Za-z '\n' | tr A-Z a-z | LC_ALL=C sort | uniq -c | sort -rn | head -n "$2"
