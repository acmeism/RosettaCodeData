def text = new StringBuilder()
    .append('---------- Ice and Fire ------------\n')
    .append('                                    \n')
    .append('fire, in end will world the say Some\n')
    .append('ice. in say Some                    \n')
    .append('desire of tasted I\'ve what From     \n')
    .append('fire. favor who those with hold I   \n')
    .append('                                    \n')
    .append('... elided paragraph last ...       \n')
    .append('                                    \n')
    .append('Frost Robert -----------------------\n').toString()

text.eachLine { line ->
    println "$line   -->   ${line.split(' ').reverse().join(' ')}"
}
