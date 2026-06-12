using Cairo

const WIDTH = 800
const HEIGHT  = 600

const Rext = 150.0   # outer radius
const Rint = 60.0    # tube radius

# Rotation angles
const A = 0.5
const B = 0.5

# precompute sines and cosines for rotation angles
const sinA = sin(A)
const cosA = cos(A)
const sinB = sin(B)
const cosB = cos(B)

# Create Cairo surface
const TORUS = CairoRGBSurface(WIDTH, HEIGHT)
const CTX = CairoContext(TORUS)

# Background
set_source_rgb(CTX, 0.04, 0.04, 0.06)
paint(CTX)

# Function to draw pixel
function putpixel(ctx, x, y, r, g, b)
    set_source_rgb(ctx, r/255, g/255, b/255)
    rectangle(ctx, x, y, 1, 1)
    fill(ctx)
end

for jj in 0:628
    j = jj / 100

    ii = 0
    while ii < 628
        i = ii / 100

        sini = sin(i)
        cosi = cos(i)
        sinj = sin(j)
        cosj = cos(j)

        # compute 3D coordinates
        h = Rext + Rint * cosj
        x = h * (cosB * cosi + sinA * sinB * sini) - Rint * cosA * sinB * sinj
        y = h * (sinB * cosi - sinA * cosB * sini) + Rint * cosA * cosB * sinj
        z = h * cosA * sini + Rint * sinA * sinj

        # Luminance
        tmp = cosj * cosi * sinB - sinA * cosj * sini * cosB - cosA * sinj * cosB
        lum = 8 * (tmp - cosi * sinj * sinA)

        if lum > 0
            bright = min(Int(round(lum * 30)), 255)
            r = bright ÷ 2
            g = bright
            b = 255
            # compute 3D perspective
            ooz = 1 / (z + 500)
            xp = Int(round(400 + x * ooz * 600))
            yp = Int(round(300 - y * ooz * 600))

            if 0 ≤ xp < WIDTH && 0 ≤ yp < HEIGHT
                putpixel(CTX, xp, yp, r, g, b)
            end
        end

        ii += 4
    end
end

# Save image as PNG file
write_to_png(TORUS, "torus.png")
