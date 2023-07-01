cat <<EOF_OUTER > just-nocenter.sh
#!/bin/sh

td() {
cat <<'EOF'
Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.
EOF
}

rows=$( td | wc -l )

# get the number of fields
fields=$(td | rs -c'$' -g1 -h | awk '{print $2}')

# get the max of the value widths
cwidth=$(td | rs -c'$' -g1 -w1 2>/dev/null | awk 'BEGIN{w=0}{if(length>w){w=length}}END{print w}')

# compute the minimum line width for the columns
lwidth=$(( (1 + cwidth) * fields ))

# left adjusted columns
td | rs -c'$' -g1 -zn -w$lwidth

echo ""

# right adjusted columns
td | rs -c'$' -g1 -znj -w$lwidth

echo ""

exit
EOF_OUTER
