function to_gray(sequence image)
    sequence color
    for i = 1 to length(image) do
        for j = 1 to length(image[i]) do
            color = and_bits(image[i][j], {#FF0000,#FF00,#FF}) /
                                          {#010000,#0100,#01} -- unpack color triple
            image[i][j] = floor(0.2126*color[1] + 0.7152*color[2] + 0.0722*color[3])
        end for
    end for
    return image
end function

function to_color(sequence image)
    for i = 1 to length(image) do
        for j = 1 to length(image[i]) do
            image[i][j] = image[i][j]*#010101
        end for
    end for
    return image
end function
