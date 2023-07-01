def a = [4.4, 2.3, -1.7, 7.5, 6.6, 0.0, 1.9, 8.2, 9.3, 4.5]
def sz = a.size()

(0..sz).each {
    println """${median(a[0..<(sz-it)])} == median(${a[0..<(sz-it)]})
${median(a[it..<sz])} == median(${a[it..<sz]})"""
}
