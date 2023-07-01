using Colors, FileIO

const colors = [colorant"black", colorant"red", colorant"green", colorant"blue",
                colorant"magenta", colorant"cyan", colorant"yellow", colorant"white"]

function getnumberwithprompt(prompt, t::Type)
    s = ""
    while (x = tryparse(t, s)) == nothing
        print("\n", prompt, ": -> ")
        s = strip(readline())
    end
    return x
end

function colorstripepng(filename)
    dpi = getnumberwithprompt("Printer DPI (dots per inch)", Int)
    pwidth, plength = getnumberwithprompt("Printer width (inches)", Float64), 10
    imgwidth, imgheight = Int(round(pwidth * dpi)), plength * dpi
    img = fill(colorant"black", imgheight, imgwidth)

    for row in 1:imgheight
        stripenum, stripewidth, colorindex = 1, div(row, dpi) + 1, 1
        for col in 1:imgwidth
            img[row, col] = colors[colorindex]
            if (stripenum += 1) % stripewidth == 0
                colorindex = mod1(colorindex + 1, length(colors))
            end
        end
    end
    save(filename, img)
end

colorstripepng("temp.png")
run(`print temp.png`)  # the run statement may need to be set up for the installed device
