using FileIO, ImageIO

function getnumberwithprompt(prompt, t::Type)
    s = ""
    while (x = tryparse(t, s)) == nothing
        print("\n", prompt, ": -> ")
        s = strip(readline())
    end
    return x
end

dpi = getnumberwithprompt("Printer DPI (dots per inch)", Int)
pwidth = getnumberwithprompt("Printer width (inches)", Float64)
plength = 10.0

imgwidth, imgheight = Int(round(pwidth * dpi)), Int(round(plength * dpi))

img = zeros(UInt8, Int(round(imgheight)), Int(round(imgwidth)))

for row in 1:imgheight, col in 1:imgwidth
    stripewidth = div(row, dpi) + 1
    img[row, col] = rem(col, stripewidth * 2) < stripewidth ? 0 : 255
end

save("temp.png", img)
run(`print temp.png`)  # the run statement may need to be set up for the installed device
