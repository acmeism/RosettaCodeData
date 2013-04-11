encode = (str, offset = 75) ->
    str.replace /(.)\1*/g, (w) ->
        w[0] + String.fromCharCode(offset+w.length)

decode = (str, offset = 75) ->
    str.split('').map((w,i) ->
        if not (i%2) then w else new Array(+w.charCodeAt(0)-offset).join(str[i-1])
    ).join('')
