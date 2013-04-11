encode = (str) ->
    str.replace /(.)\1*/g, (w) ->
        w[0] + w.length

decode = (str) ->
    str.replace /(.)(\d+)/g, (m,w,n) ->
        new Array(+n+1).join(w)

console.log s = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
console.log encode s
console.log decode encode s
