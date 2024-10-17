using AnsiColor

function showbasecolors()
    for color in keys(Base.text_colors)
        print_with_color(color, " ", string(color), " ")
    end
    println()
end

function showansicolors()
    for fore in keys(AnsiColor.COLORS)
        print(@sprintf("%15s ", fore))
        for back in keys(AnsiColor.COLORS)
            print(" ", colorize(fore, "RC", background=back), " ")
        end
        println()
    end
    println()
    for eff in keys(AnsiColor.MODES)
        print(@sprintf(" %s ", eff), colorize("default", "RC", mode=eff))
    end
    println()
end

if Base.have_color
    println()
    println("Base Colors")
    showbasecolors()
    println("\nusing AnsiColor")
    showansicolors()
    println()
else
    println("This terminal appears not to support color.")
end
