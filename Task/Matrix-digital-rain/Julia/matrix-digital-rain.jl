using Gtk, Colors, Cairo
import Base.iterate, Base.IteratorSize, Base.IteratorEltype

const caps = [c for c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
startfall() = rand() < 0.2
endfall() = rand() < 0.2
startblank() = rand() < 0.1
endblank() = rand() < 0.05
bechangingchar() = rand() < 0.03

struct RainChars chars::Vector{Char} end
Base.IteratorSize(s::RainChars) = Base.IsInfinite()
Base.IteratorEltype(s::RainChars) = Char
function Base.iterate(rain::RainChars, state = (true, false, 0))
    c = '\0'
    isfalling, isblank, blankcount = state
    if isfalling # falling, so feed the column
        if isblank
            c = ' '
            ((blankcount += 1) > 12) && (isblank = endblank())
        else
            c = bechangingchar() ? '~' : rand(rain.chars)
            isblank, blankcount = startblank(), 0
        end
        endfall() && (isfalling = false)
    else
        isfalling = startfall()
    end
    return c, (isfalling, isblank, blankcount)
end

function digitalrain()
    mapwidth, mapheight, fontpointsize = 800, 450, 14
    windowmaxx = div(mapwidth, Int(round(fontpointsize * 0.9)))
    windowmaxy = div(mapheight, fontpointsize)
    basebuffer = fill(' ', windowmaxy, windowmaxx)
    bkcolor, rcolor, xcolor = colorant"black", colorant"green", colorant"limegreen"

    columngenerators = [Iterators.Stateful(RainChars(caps)) for _ in 1:windowmaxx]

    win = GtkWindow("Digital Rain Effect", mapwidth, mapheight) |>
        (GtkFrame() |> (can = GtkCanvas()))
    set_gtk_property!(can, :expand, true)

    draw(can) do widget
        ctx = Gtk.getgc(can)
        select_font_face(ctx, "Leonardo\'s mirrorwriting", Cairo.FONT_SLANT_NORMAL,
            Cairo.FONT_WEIGHT_BOLD)
        set_font_size(ctx, fontpointsize)
        set_source(ctx, bkcolor)
        rectangle(ctx, 0, 0, mapwidth, mapheight)
        fill(ctx)
        set_source(ctx, rcolor)
        for i in 1:size(basebuffer)[1], j in 1:size(basebuffer)[2]
            move_to(ctx, j * fontpointsize * 0.9, i * fontpointsize)
            c = basebuffer[i, j]
            if c == '~'
				set_source(ctx, xcolor)
                show_text(ctx, String([rand(caps)]))
				set_source(ctx, rcolor)
            else
                show_text(ctx, String([c]))
            end
        end
    end

    while true
        for col in 1:windowmaxx
            c = popfirst!(columngenerators[col])
            if c != '\0'
                basebuffer[2:end, col] .= basebuffer[1:end-1, col]
                basebuffer[1, col] = c
            end
        end
        draw(can)
        Gtk.showall(win)
        sleep(0.05)
    end
end

digitalrain()
