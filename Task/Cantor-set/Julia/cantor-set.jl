const width = 81
const height = 5

function cantor!(lines, start, len, idx)
    seg = div(len, 3)
    if seg > 0
        for i in idx+1:height, j in start + seg + 1: start + seg * 2
            lines[i, j] = ' '
        end
        cantor!(lines, start, seg, idx + 1)
        cantor!(lines, start + 2 * seg, seg, idx + 1)
    end
end

lines = fill(UInt8('#'), height, width)
cantor!(lines, 0, width, 1)

for i in 1:height, j in 1:width
    print(Char(lines[i, j]), j == width ? "\n" : "")
end
