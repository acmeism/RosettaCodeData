import pygame

WIDTH, HEIGHT = 350, 400
RADIUS = 50
FPS = 20


def calculate_angle_line_pos(
    start: tuple[int | float, int | float], radius: int | float, angle: int | float
):
    vec = pygame.math.Vector2(0, -radius).rotate((angle) % 360)
    return start[0] + vec.x, start[1] + vec.y


class Spinner:
    def __init__(
        self,
        pos: tuple[int, int],
        color: tuple[int, int, int],
        radius=10,
        speed=110,
        starting_angle=360,
        line_width=2,
    ):
        self.__pos = pos
        self.__radius = radius
        self.__angle = starting_angle
        self.__color = color
        self.__speed = speed
        self.__line_width = line_width

    def draw(self, surface: pygame.Surface):
        pygame.draw.line(
            surface,
            self.__color,
            self.__pos,
            calculate_angle_line_pos(self.__pos, self.__radius, self.__angle),
            self.__line_width,
        )

        self.__angle = (self.__angle - self.__speed) % 361


def main():
    pygame.init()
    pygame.display.set_caption("Spinners")

    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    clock = pygame.time.Clock()

    cx, cy = WIDTH // 2, HEIGHT // 2

    spinner = Spinner((cx - RADIUS, cy - RADIUS), (255, 0, 0), RADIUS)
    spinner2 = Spinner((cx, cy), (0, 0, 255), RADIUS)
    spinner3 = Spinner((cx + RADIUS, cy - RADIUS), (255, 255, 0), RADIUS)
    spinner4 = Spinner((cx - RADIUS, cy + RADIUS), (255, 255, 255), RADIUS)
    spinner5 = Spinner((cx + RADIUS, cy + RADIUS), (255, 175, 0), RADIUS)

    running = True

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        screen.fill((44, 45, 44))

        pygame.draw.circle(screen, (100, 100, 100), (cx, cy), 100 + RADIUS + 2)
        pygame.draw.circle(screen, (0, 0, 0), (cx, cy), 100 + RADIUS)

        spinner.draw(screen)
        spinner2.draw(screen)
        spinner3.draw(screen)
        spinner4.draw(screen)
        spinner5.draw(screen)

        pygame.display.flip()

        clock.tick(FPS)

    pygame.quit()


if __name__ == "__main__":
    main()
