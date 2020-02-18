from StringIO import StringIO

textinfile = '''Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.'''

j2justifier = dict(L=str.ljust, R=str.rjust, C=str.center)

def aligner(infile, justification = 'L'):
  ''' \
  Justify columns of textual tabular input where the row separator is the newline
  and the field separator is a 'dollar' character.
  justification can be L, R, or C; (Left, Right, or Centered).

  Return the justified output as a string
  '''
  assert justification in j2justifier, "justification can be L, R, or C; (Left, Right, or Centered)."
  justifier = j2justifier[justification]

  fieldsbyrow= [line.strip().split('$') for line in infile]
  # pad to same number of fields per row
  maxfields = max(len(row) for row in fieldsbyrow)
  fieldsbyrow = [fields + ['']*(maxfields - len(fields))
                    for fields in fieldsbyrow]
  # rotate
  fieldsbycolumn = zip(*fieldsbyrow)
  # calculate max fieldwidth per column
  colwidths = [max(len(field) for field in column)
               for column in fieldsbycolumn]
  # pad fields in columns to colwidth with spaces
  fieldsbycolumn = [ [justifier(field, width) for field in column]
                     for width, column in zip(colwidths, fieldsbycolumn) ]
  # rotate again
  fieldsbyrow = zip(*fieldsbycolumn)

  return "\n".join( " ".join(row) for row in fieldsbyrow)


for align in 'Left Right Center'.split():
  infile = StringIO(textinfile)
  print "\n# %s Column-aligned output:" % align
  print aligner(infile, align[0])
