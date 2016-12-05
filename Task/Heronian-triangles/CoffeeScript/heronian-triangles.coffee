heronArea = (a, b, c) ->
    s = (a + b + c) / 2
    Math.sqrt s * (s - a) * (s - b) * (s - c)

isHeron = (h) -> h % 1 == 0 and h > 0

gcd = (a, b) ->
    leftover = 1
    dividend = if a > b then a else b
    divisor = if a > b then b else a
    until leftover == 0
        leftover = dividend % divisor
        if leftover > 0
            dividend = divisor
            divisor = leftover
    divisor

list = []
for c in [1..200]
    for b in [1..c]
        for a in [1..b]
            area = heronArea(a, b, c)
            if gcd(gcd(a, b), c) == 1 and isHeron(area)
                list.push new Array(a, b, c, a + b + c, area)

sort = (list) ->
    swapped = true
    while swapped
        swapped = false
        for i in [1..list.length-1]
            if list[i][4] < list[i - 1][4] or list[i][4] == list[i - 1][4] and list[i][3] < list[i - 1][3]
                temp = list[i]
                list[i] = list[i - 1]
                list[i - 1] = temp
                swapped = true
sort list

# some results:
console.log 'primitive Heronian triangles with sides up to 200: ' + list.length
console.log 'First ten when ordered by increasing area, then perimeter:'
for i in list[0..10-1]
    console.log  i[0..2].join(' x ') + ', p = ' + i[3] + ', a = ' + i[4]

console.log '\nHeronian triangles with area = 210:'
for i in list
    if i[4] == 210
        console.log i[0..2].join(' x ') + ', p = ' + i[3]
