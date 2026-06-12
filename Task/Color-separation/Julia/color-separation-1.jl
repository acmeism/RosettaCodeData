using Images, FileIO

@enum ColorScheme RGB CMY CMYK

""" Convert an image to different color schemes and save them as separate images. """
function convert_to_color_scheme(original_image, color_scheme::ColorScheme)
    height, width = size(original_image)
    argb_image = ARGB32.(original_image)
    original_pixels = reinterpret(UInt32, argb_image)
    num_channels = length(string(color_scheme))
    pixels = Matrix{UInt32}(undef, num_channels, length(original_pixels))
    for (i, pixel) in eachindex(original_pixels)
        alpha = (pixel >> 24) & 0xff
        red = (pixel >> 16) & 0xff
        green = (pixel >> 8) & 0xff
        blue = pixel & 0xff
        if color_scheme == RGB
            pixels[1, i] = (alpha << 24) | (red << 16) | 0 | 0
            pixels[2, i] = (alpha << 24) | 0 | (green << 8) | 0
            pixels[3, i] = (alpha << 24) | 0 | 0 | blue
        elseif color_scheme == CMY
            pixels[1, i] = (alpha << 24) | (red << 16) | (255 << 8) | 255
            pixels[2, i] = (alpha << 24) | (255 << 16) | (green << 8) | 255
            pixels[3, i] = (alpha << 24) | (255 << 16) | (255 << 8) | blue
        elseif color_scheme == CMYK
            colors = cmyk_colors(alpha, red, green, blue)
            for j in 1:4
                pixels[j, i] = colors[j]
            end
        end
    end
    # Save images for each channel
    for i in 1:num_channels
        pixel_matrix = reshape(pixels[i, :], height, width)
        argb_pixels = reinterpret(ARGB32, pixel_matrix)
        new_image = argb_pixels

        filename = "Lenna$(i-1).png"
        save(filename, new_image)
    end
end

""" Convert RGB to CMYK color space. """
function cmyk_colors(alpha, red, green, blue)
    rc, gc, bc = 255 - red, 255 - green, 255 - blue
    k = min(rc, gc, bc)
    kc = 255 - k
    color_k = (alpha << 24) | (kc << 16) | (kc << 8) | kc
    kc == 0 && return UInt32[0, 0, 0, color_k]

    c, m, y = ((rc - k) * 255) ÷ kc, ((gc - k) * 255) ÷ kc, ((bc - k) * 255) ÷ kc
    color_c = (alpha << 24) | ((255 - c) << 16) | (255 << 8) | 255
    color_m = (alpha << 24) | (255 << 16) | ((255 - m) << 8) | 255
    color_y = (alpha << 24) | (255 << 16) | (255 << 8) | (255 - y)

    return UInt32[color_c, color_m, color_y, color_k]
end

const original_image = load("./Lenna.png") # upper left on image below
convert_to_color_scheme(original_image, RGB)
