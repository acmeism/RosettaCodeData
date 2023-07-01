def csv = []
def loadCsv = { source -> source.splitEachLine(/,/) { csv << it.collect { it } } }
def saveCsv = { target -> target.withWriter { writer -> csv.each { writer.println it.join(',') } } }

loadCsv new File('csv.txt')
csv[0][0] = 'Column0'
(1..4).each { i -> csv[i][i] = i * 100 }
saveCsv new File('csv_out.txt')
