from PIL import Image

# Open the image
image = Image.open("lena.jpg")
# Get the width and height of the image
width, height = image.size
# Calculate the amount of pixels
amount = width * height

# Total amount of greyscale
total = 0
# B/W image
bw_image = Image.new('L', (width, height), 0)
# Bitmap image
bm_image = Image.new('1', (width, height), 0)

for h in range(0, height):
    for w in range(0, width):
        r, g, b = image.getpixel((w, h))

        greyscale = int((r + g + b) / 3)
        total += greyscale

        bw_image.putpixel((w, h), gray_scale)

# The average greyscale
avg = total / amount

black = 0
white = 1

for h in range(0, height):
    for w in range(0, width):
        v = bw_image.getpixel((w, h))

        if v >= avg:
            bm_image.putpixel((w, h), white)
        else:
            bm_image.putpixel((w, h), black)

bw_image.show()
bm_image.show()
