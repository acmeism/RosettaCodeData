def rawTextInput = '''Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.'''

['Left', 'Center', 'Right'].each { align ->
    println "${align} Justified:"
    alignColumns(align, rawTextInput)
    println()
}
