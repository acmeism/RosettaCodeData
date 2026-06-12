from PIL import Image, ImageDraw


def diamond(
    img_size: tuple[int, int] = (400, 350),
    diamond_width=250,
    diamond_height=250,
    line_width=3,
    filename='out.png'
):
    w, h = img_size

    with Image.new('RGB', img_size, 'black') as img:
        draw = ImageDraw.Draw(img)
        cx, cy = (w + diamond_width) // 2, h // 2

        l1x = cx - diamond_width
        l2x, l2y = l1x + (diamond_width * 0.25), cy - diamond_height // 2
        l1y = l2y + diamond_height * 0.25

        dx, dy = l1x + diamond_width // 2, cy + diamond_height // 2

        draw.line([(l1x, l1y), (l1x + diamond_width, l1y)], width=line_width)
        draw.line([(l2x, l2y), (l2x + diamond_width / 2, l2y)],
                  width=line_width)

        draw.line([(l1x, l1y), (dx, dy)], width=line_width)
        draw.line([(l1x, l1y), (l2x, l2y)], width=line_width)
        draw.line([(l2x, l2y), (dx, dy)], width=line_width)
        draw.line([(l2x + diamond_width // 2, l2y),
                  (dx, dy)], width=line_width)
        draw.line([(l1x + diamond_width, l1y), (dx, dy)], width=line_width)
        draw.line([(l1x + diamond_width, l1y),
                  (l2x + diamond_width // 2, l2y)], width=line_width)

        img.save(filename)

if __name__ == '__main__':
    diamond()
