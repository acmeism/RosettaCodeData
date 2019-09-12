def str = 'abcdefgh'
def n = 2
def m = 3
// #1
println str[n..n+m-1]
/* or */
println str[n..<(n+m)]
// #2
println str[n..-1]
// #3
println str[0..-2]
// #4
def index1 = str.indexOf('d')
println str[index1..index1+m-1]
/* or */
println str[index1..<(index1+m)]
// #5
def index2 = str.indexOf('de')
println str[index2..index2+m-1]
/* or */
println str[index2..<(index2+m)]
