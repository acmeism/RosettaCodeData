# Windows GDI version
function getpixelcolors(x, y)
    hdc = ccall((:GetDC, "user32.dll"), UInt32, (UInt32,), 0)
    pxl = ccall((:GetPixel, "gdi32.dll"), UInt32, (UInt32, Cint, Cint), hdc, Cint(x), Cint(y))
    return pxl & 0xff, (pxl >> 8) & 0xff, (pxl >> 16) & 0xff
end

const x = 120
const y = 100
cols = getpixelcolors(x, y)
println("At screen point (x=$x, y=$y) the color RGB components are red: $(cols[1]), green: $(cols[2]), and blue: $(cols[3])")
