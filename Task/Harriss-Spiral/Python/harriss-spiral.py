import math
import random

import pygame

WIDTH, HEIGHT = 1000, 750
HR = 1.3247
SHOW_LINES = False


def draw_arc_segment(
    x: float,
    y: float,
    angle: float,
    length: float,
    iteration: int,
    line_width: int,
    surface: pygame.Surface,
):
    if iteration <= 0:
        return

    heading = ""
    arc_color = (255, 255, 255)

    x_end = x + length * math.cos(math.radians(angle))
    y_end = y + length * math.sin(math.radians(angle))

    if math.floor(y_end) < math.floor(y):
        heading = "RIGHT"

    if math.floor(x_end) < math.floor(x):
        heading = "UPPER"

    if math.floor(y_end) > math.floor(y):
        heading = "LEFT"

    if math.floor(x_end) > math.floor(x):
        heading = "LOWER"

    if SHOW_LINES:
        pygame.draw.line(surface, (0, 0, 0), (x, y), (x_end, y_end))

    centre_x, centre_y = 0, 0

    match heading:
        case "RIGHT":
            centre_x = x - length / 2
            centre_y = y - length / 2
            arc_color = random.choice(((255, 255, 0), (0, 255, 0)))

        case "UPPER":
            centre_x = x - length / 2
            centre_y = y + length / 2
            angle += 180
            arc_color = (255, 0, 0)

        case "LEFT":
            centre_x = x + length / 2
            centre_y = y + length / 2
            arc_color = (0, 0, 255)

        case "LOWER":
            centre_x = x + length / 2
            centre_y = y - length / 2
            angle += 180
            arc_color = random.choice(((255, 175, 0), (0, 0, 0)))

    radius = 0.7 * length
    pygame.draw.arc(
        surface,
        arc_color,
        pygame.Rect(
            int(centre_x - radius),
            int(centre_y - radius),
            int(radius * 2),
            int(radius * 2),
        ),
        math.radians(angle + 45),
        math.radians(angle + 45 + 90),
    )

    if heading == "LOWER" or heading == "UPPER":
        angle -= 180

    draw_arc_segment(
        x_end, y_end, angle - 90, length / HR, iteration - 1, line_width, surface
    )


def draw_harriss_spiral(surface: pygame.Surface):
    HR2 = HR * HR
    HR3 = HR2 * HR
    HR4 = HR2 * HR2
    HR5 = HR4 * HR
    HR6 = HR4 * HR2
    HR8 = HR4 * HR4

    start_x = WIDTH / 2.0 + 50.0
    start_y = HEIGHT - 75.0
    initial_length = 600 / HR2

    draw_arc_segment(
        start_x + initial_length / HR,
        start_y - (initial_length + initial_length / HR2),
        0,
        initial_length / HR4,
        4,
        6,
        surface,
    )
    draw_arc_segment(
        start_x + initial_length / HR4,
        start_y - (initial_length + initial_length / HR2),
        270.0,
        initial_length / HR5,
        3,
        6,
        surface,
    )
    draw_arc_segment(
        start_x - (initial_length / HR + initial_length / HR3),
        start_y - (initial_length + initial_length / HR2),
        270.0,
        initial_length / HR5,
        3,
        6,
        surface,
    )
    draw_arc_segment(
        start_x - (initial_length / HR + initial_length / HR3),
        start_y - initial_length / HR8,
        180.0,
        initial_length / HR6,
        2,
        6,
        surface,
    )
    draw_arc_segment(
        start_x - initial_length / HR4,
        start_y - initial_length / HR3,
        -270.0,
        initial_length / HR4,
        3,
        8,
        surface,
    )
    draw_arc_segment(
        start_x - initial_length / HR4,
        start_y - initial_length / HR,
        0.0,
        initial_length / HR5,
        2,
        8,
        surface,
    )
    draw_arc_segment(
        start_x - initial_length / HR,
        start_y - initial_length,
        270.0,
        initial_length / HR2,
        5,
        12,
        surface,
    )
    draw_arc_segment(
        start_x - initial_length / HR,
        start_y - initial_length / HR3,
        180.0,
        initial_length / HR3,
        4,
        12,
        surface,
    )
    draw_arc_segment(
        start_x, start_y - initial_length, 0.0, initial_length / HR, 6, 16, surface
    )
    draw_arc_segment(start_x, start_y, -90.0, initial_length, 7, 16, surface)


def main():
    pygame.init()
    pygame.display.set_caption("Harriss Spiral")

    screen = pygame.display.set_mode((WIDTH, HEIGHT))

    running = True

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        screen.fill((255, 255, 255) if not SHOW_LINES else (100, 100, 100))
        draw_harriss_spiral(screen)
        pygame.display.flip()

    pygame.quit()


if __name__ == "__main__":
    main()
