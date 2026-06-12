using Cairo

const WIDTH = 600
const HEIGHT  = 600

# Create Cairo surface
const DIAMOND = CairoRGBSurface(WIDTH, HEIGHT)
const CTX = CairoContext(DIAMOND)


function drawdiamond()
    # Background
    set_source_rgb(CTX, 0.91, 0.94, 0.96)
    paint(CTX)

    # Diamond color
    set_source_rgb(CTX, 0.831, 0.686, 0.216)
    set_line_width(CTX, 4)


    cx = 300  # center
    y1 = 150  # top edge
    y2 = 230  # wide part
    y3 = 450  # bottom tip

    # Symmetrical drawing around the cx axis.
    move_to(CTX, cx - 80, y1)
    line_to(CTX, cx + 80, y1)
    stroke(CTX)
    move_to(CTX, cx + 80, y1)
    line_to(CTX, cx + 160, y2)
    stroke(CTX)
    move_to(CTX, cx + 160, y2)
    line_to(CTX, cx, y3)
    stroke(CTX)
    move_to(CTX, cx, y3)
    line_to(CTX, cx - 160, y2)
    stroke(CTX)
    move_to(CTX, cx - 160, y2)
    line_to(CTX, cx - 80, y1)
    stroke(CTX)

    # Inner edges (facets) aligned to the center line.
    move_to(CTX, cx - 160, y2)
    line_to(CTX, cx + 160, y2)
    stroke(CTX)
    move_to(CTX, cx - 80, y1)
    line_to(CTX, cx, y3)
    stroke(CTX)
    move_to(CTX, cx + 80, y1)
    line_to(CTX, cx, y3)
    stroke(CTX)
end

drawdiamond()

# Save image as PNG file
write_to_png(DIAMOND, "diamond.png")
display(DIAMOND)
