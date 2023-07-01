include get.e

function get2(integer fn)
    sequence temp
    temp = get(fn)
    return temp[2] - temp[1]*temp[1]
end function

function read_ppm(sequence filename)
    sequence image, line
    integer dimx, dimy, maxcolor
    atom fn
    fn = open(filename, "rb")
    if fn < 0 then
        return -1 -- unable to open
    end if
    line = gets(fn)
    if not equal(line,"P6\n") then
        return -1 -- only ppm6 files are supported
    end if
    dimx = get2(fn)
    if dimx < 0 then
        return -1
    end if
    dimy = get2(fn)
    if dimy < 0 then
        return -1
    end if
    maxcolor = get2(fn)
    if maxcolor != 255 then
        return -1 -- maxcolors other then 255 are not supported
    end if
    image = repeat(repeat(0,dimy),dimx)
    for y = 1 to dimy do
        for x = 1 to dimx do
            image[x][y] = getc(fn)*#10000 + getc(fn)*#100 + getc(fn)
        end for
    end for
    close(fn)
    return image
end function
