'''
cat <<'EOF' > align_columns.dat
Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.
EOF
'''

for align in '<^>':
  rows = [ line.strip().split('$') for line in open('align_columns.dat') ]
  fmts = [ '{:%s%d}' % (align, max( len(row[i]) if i < len(row) else 0 for row in rows ))
           for i in range(max(map(len, rows))) ]
  for row in rows:
    print(' '.join(fmts).format(*(row + [''] * len(fmts))))
  print('')
