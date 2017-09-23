# rgb is a JSON object: { "red": _, "green": _, "blue": _}

def xor_pattern(width; height; rgb1; rgb2):
    # create colour table
    256 as $size
    | (reduce range(0;$size) as $i
        ([]; . + [
        {"red":   (rgb1.red + (rgb2.red - rgb1.red) * $i / $size),
         "green": (rgb1.green + (rgb2.green - rgb1.green) * $i / $size),
         "blue":  (rgb1.blue + (rgb2.blue - rgb1.blue) * $i / $size) }])
      )  as $colours
    # create the image
    | svg(width; height),
      ( (range(0;width) as $x
        | range(0;height) as $y
        |   pixel($x; $y; $colours[ xor($x; $y) % $size] ) ) ),
     "</svg>" ;
