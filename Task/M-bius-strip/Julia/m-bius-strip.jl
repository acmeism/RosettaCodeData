using Cairo


const WIDTH = 600
const HEIGHT = 600

# Create Cairo surface
const MOEBIUS = CairoRGBSurface(WIDTH, HEIGHT)
const CTX = CairoContext(MOEBIUS)

# Increment u by just 0.25 degrees in radians. The goal is discrete lines,
# but lines that are close enough to appear as texture on a 3D surface to the eye.
const ONE_QUARTER_DEGREE = π / 720

function drawmobius()
    radius, halfWidth, u = 150, 60, 0

    # Fill a dark gray background
    set_source_rgb(CTX, 0.11, 0.18, 0.18)
    paint(CTX)

    # Set line color and width for the Möbius strip edges
    set_source_rgb(CTX, 0.61, 0.11, 0.19)  # dark red
    set_line_width(CTX, 1.1)

    for u in 0:ONE_QUARTER_DEGREE:(2π - ONE_QUARTER_DEGREE)
        # Inner edge point.
        v1 = -halfWidth
        x1 = (radius + v1 * cos(u)) * cos(2u)
        y1 = (radius + v1 * cos(u)) * sin(2u)
        z1 = v1 * sin(u)
        px1 = round(300 + x1 + (z1 * 0.3))
        py1 = round(300 + y1 - (z1 * 0.3))

        # Outer edge point.
        v2 = halfWidth
        x2 = (radius + v2 * cos(u)) * cos(2u)
        y2 = (radius + v2 * cos(u)) * sin(2u)
        z2 = v2 * sin(u)
        px2 = round(300 + x2 + (z2 * 0.3))
        py2 = round(300 + y2 - (z2 * 0.3))

        # Draw a dark red line between the two edges.
        move_to(CTX, px1, py1)
        line_to(CTX, px2, py2)
        stroke(CTX)
    end
end

drawmobius()

# Save image as PNG file
write_to_png(MOEBIUS, "moebius.png")
