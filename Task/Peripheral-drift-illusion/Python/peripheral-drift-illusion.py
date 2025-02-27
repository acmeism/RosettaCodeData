import pygame

width, height = 750, 700

RADIUS = width // 15

width += RADIUS
height += RADIUS

def calculate_angle_pos(
    start: tuple[int | float, int | float], radius: int | float, angle: int | float
):
    vec = pygame.math.Vector2(0, -radius).rotate((angle) % 360)
    return start[0] + vec.x, start[1] + vec.y

def main():
    pygame.init()
    pygame.display.set_caption('Drift Illusion')

    screen = pygame.display.set_mode((width, height))

    running = True

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        screen.fill((0, 125, 0))

        step = 360 / 15
        angle = step

        for y in range(RADIUS, height, RADIUS):
            for x in range(RADIUS, width, RADIUS):
                rad = RADIUS // 3

                comp_angle = (angle + 180) % 361

                x1, y1 = calculate_angle_pos((x, y), (1/2.5) * rad, angle)
                x2, y2 = calculate_angle_pos((x, y), (1/2.5) * rad, comp_angle)

                pygame.draw.circle(screen, (255, 255, 255), (x1, y1), rad)
                pygame.draw.circle(screen, (0, 0, 0), (x2, y2), rad)
                pygame.draw.circle(screen, (0, 0, 255), (x, y), rad)

                angle = (angle - step) % 361

            angle = (angle - step) % 361

        pygame.display.flip()

    pygame.quit()

if __name__ == '__main__':
    main()
