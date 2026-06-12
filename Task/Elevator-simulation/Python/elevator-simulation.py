import pygame
import random

WIDTH, HEIGHT = 800, 600

GRAY = (125, 125, 125)
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
YELLOW = (255, 255, 0)
ORANGE = (255, 175, 0)
LIGHT_BLUE = (0, 175, 255)


class Button:
    def __init__(
        self,
        x: int,
        y: int,
        width: int,
        height: int,
        border_radius: float,
        text: str,
        bg_color: pygame.typing.ColorLike,
        fg_color: pygame.typing.ColorLike,
        font: pygame.Font,
        on_click_val=None,
    ):
        self.__btn_rect = pygame.Rect(x, y, width, height)
        self.__border_radius = border_radius
        self.__text = text
        self.__bg_color = bg_color
        self.__fg_color = fg_color
        self.__on_click_val = on_click_val
        self.__font = font

    def draw(self, surface: pygame.Surface):
        text_surf = self.__font.render(self.__text, False, self.__fg_color)

        pygame.draw.rect(
            surface,
            self.__bg_color,
            self.__btn_rect,
            border_radius=int(self.__btn_rect.width * self.__border_radius),
        )

        text_rect = text_surf.get_rect(center=self.__btn_rect.center)
        surface.blit(text_surf, text_rect)

    def mouse_over(self):
        return self.__btn_rect.collidepoint(pygame.mouse.get_pos())

    def on_click(self):
        return self.__on_click_val


class Floor:
    def __init__(
        self,
        x: int,
        y: int,
        width: int,
        height: int,
        is_elevator: bool,
        doors_open: bool,
        is_wait: bool,
        font: pygame.Font,
    ):
        self.__rect = pygame.Rect(x, y, width, height)
        self.__is_elevator = is_elevator
        self.__doors_open = doors_open
        self.__is_wait = is_wait
        self.__font = font

    def draw(self, surface: pygame.Surface):
        pygame.draw.rect(surface, WHITE, self.__rect)

        if not self.__is_elevator and self.__is_wait:
            circle_rect = pygame.draw.circle(surface, YELLOW, self.__rect.center, 25)
            text_surf = self.__font.render("WAIT", False, BLACK)
            text_rect = text_surf.get_rect(center=circle_rect.center)
            surface.blit(text_surf, text_rect)

        elif self.__doors_open and self.__is_elevator:
            third = self.__rect.width // 3
            pygame.draw.rect(
                surface,
                LIGHT_BLUE,
                pygame.Rect(
                    self.__rect.left, self.__rect.top, third, self.__rect.height
                ),
            )
            pygame.draw.rect(
                surface,
                LIGHT_BLUE,
                pygame.Rect(
                    self.__rect.right - third,
                    self.__rect.top,
                    third,
                    self.__rect.height,
                ),
            )

        elif self.__is_elevator:
            pygame.draw.rect(surface, LIGHT_BLUE, self.__rect)


def get_random_start_wait_floors():
    floors = list(range(7))

    wait_floor = random.choice(floors)
    floors.remove(wait_floor)
    start_floor = random.choice(floors)

    return wait_floor, start_floor


def main():
    pygame.init()
    pygame.display.set_caption("Elevator simulation")

    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    clock = pygame.time.Clock()
    font = pygame.Font(None, size=17)

    running = True

    panel_x = 320
    panel_y = 200

    btn_width = 50
    btn_height = 50

    start_y_inc = 10
    floor_btns = []

    door_open = True
    is_moving = False
    reached_wait = False

    for floor in range(6, 0, -2):
        floor_btns.append(
            Button(
                panel_x + 30,
                panel_y + start_y_inc,
                btn_width,
                btn_height,
                0.5,
                str(floor - 1),
                GRAY,
                BLACK,
                font,
                floor - 1,
            )
        )

        floor_btns.append(
            Button(
                panel_x + btn_width + 40,
                panel_y + start_y_inc,
                btn_width,
                btn_height,
                0.5,
                str(floor),
                GRAY,
                BLACK,
                font,
                floor,
            )
        )

        if floor == 2:
            floor_btns.append(
                Button(
                    panel_x + btn_width + 10,
                    panel_y + (start_y_inc := start_y_inc + btn_height + 10),
                    btn_width,
                    btn_height,
                    0.5,
                    "GF",
                    GRAY,
                    BLACK,
                    font,
                    0,
                )
            )

        start_y_inc += btn_height + 10

    close_door_btn = Button(
        panel_x + btn_width + 10,
        panel_y + start_y_inc,
        btn_width,
        btn_height,
        0.5,
        "><",
        GRAY,
        BLACK,
        font,
    )

    wait_floor, start_floor = get_random_start_wait_floors()
    current_floor = start_floor

    panel_rect = pygame.Rect(panel_x, panel_y, (btn_width // 2) * 7, 350)
    upper_rect = pygame.Rect(
        panel_x + ((btn_width // 2) * 7) // 2 - btn_width,
        panel_y - (btn_height * 2) - 40,
        btn_width * 2,
        btn_height * 2 + 30,
    )

    up_btn = Button(
        upper_rect.centerx - (btn_width // 2),
        upper_rect.top + 10,
        btn_width,
        btn_height,
        0.5,
        "^",
        GRAY,
        BLACK,
        font,
    )

    down_btn = Button(
        upper_rect.centerx - (btn_width // 2),
        upper_rect.top + btn_width + 20,
        btn_width,
        btn_height,
        0.5,
        "v",
        GRAY,
        BLACK,
        font,
    )

    restart_btn = Button(
        WIDTH - 150, 150, 100, btn_height, 0, "Restart", ORANGE, WHITE, font
    )

    exit_btn = Button(WIDTH - 150, 220, 100, btn_height, 0, "Exit", ORANGE, WHITE, font)

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

            elif event.type == pygame.MOUSEBUTTONDOWN:
                for floor_btn in floor_btns:
                    if floor_btn.mouse_over():
                        start_floor = floor_btn.on_click()
                        is_moving = True
                        break

                if close_door_btn.mouse_over():
                    door_open = not door_open

                elif up_btn.mouse_over():
                    start_floor = 6
                    is_moving = True

                elif down_btn.mouse_over():
                    start_floor = 0
                    is_moving = True

                elif restart_btn.mouse_over():
                    wait_floor, start_floor = get_random_start_wait_floors()
                    current_floor = start_floor
                    reached_wait = False
                    is_moving = False
                    door_open = True

                elif exit_btn.mouse_over():
                    running = False

        screen.fill((0, 0, 0))

        pygame.draw.rect(screen, ORANGE, panel_rect)
        pygame.draw.rect(screen, ORANGE, upper_rect)

        for btn in floor_btns:
            btn.draw(screen)

        up_btn.draw(screen)
        down_btn.draw(screen)
        close_door_btn.draw(screen)
        restart_btn.draw(screen)
        exit_btn.draw(screen)

        floor_height = HEIGHT // 7
        floor_height = (HEIGHT - floor_height) // 7
        start_y = floor_height

        indicator_rect = pygame.draw.rect(
            screen,
            ORANGE,
            pygame.Rect(100, (floor_height // 2) - 10, 100, floor_height // 2),
        )

        indicator_text = font.render(
            "GF" if current_floor == 0 else str(current_floor), False, WHITE
        )
        indicator_text_rect = indicator_text.get_rect(center=indicator_rect.center)
        screen.blit(indicator_text, indicator_text_rect)

        for i in range(6, -1, -1):
            floor_text = font.render("GF" if i == 0 else str(i), False, WHITE)
            screen.blit(
                floor_text,
                (100 - floor_text.width - 10, start_y + (floor_height - 10) // 2),
            )
            floor = Floor(
                100,
                start_y,
                100,
                floor_height - 10,
                i == current_floor,
                current_floor == start_floor and door_open,
                i == wait_floor and current_floor != i and not reached_wait,
                font,
            )
            floor.draw(screen)
            start_y += floor_height

        if is_moving:
            if not reached_wait:
                if (
                    current_floor < wait_floor
                    and current_floor < start_floor
                    and start_floor > wait_floor
                ):
                    start_floor = wait_floor

                elif (
                    current_floor > wait_floor
                    and current_floor > start_floor
                    and start_floor < wait_floor
                ):
                    start_floor = wait_floor

            if current_floor == start_floor:
                if current_floor == wait_floor:
                    reached_wait = True

                is_moving = False
                door_open = True

            elif current_floor > start_floor:
                current_floor -= 1
            elif current_floor < start_floor:
                current_floor += 1

        clock.tick(5)
        pygame.display.flip()

    pygame.quit()


if __name__ == "__main__":
    main()
