from __future__ import annotations

import itertools
import random

from enum import Enum

from typing import Any
from typing import Tuple

import pygame as pg

from pygame import Color
from pygame import Rect

from pygame.surface import Surface

from pygame.sprite import AbstractGroup
from pygame.sprite import Group
from pygame.sprite import RenderUpdates
from pygame.sprite import Sprite


class Direction(Enum):
    UP = (0, -1)
    DOWN = (0, 1)
    LEFT = (-1, 0)
    RIGHT = (1, 0)

    def opposite(self, other: Direction):
        return (self[0] + other[0], self[1] + other[1]) == (0, 0)

    def __getitem__(self, i: int):
        return self.value[i]


class SnakeHead(Sprite):
    def __init__(
        self,
        size: int,
        position: Tuple[int, int],
        facing: Direction,
        bounds: Rect,
    ) -> None:
        super().__init__()
        self.image = Surface((size, size))
        self.image.fill(Color("aquamarine4"))
        self.rect = self.image.get_rect()
        self.rect.center = position
        self.facing = facing
        self.size = size
        self.speed = size
        self.bounds = bounds

    def update(self, *args: Any, **kwargs: Any) -> None:
        # Move the snake in the direction it is facing.
        self.rect.move_ip(
            (
                self.facing[0] * self.speed,
                self.facing[1] * self.speed,
            )
        )

        # Move to the opposite side of the screen if the snake goes out of bounds.
        if self.rect.right > self.bounds.right:
            self.rect.left = 0
        elif self.rect.left < 0:
            self.rect.right = self.bounds.right

        if self.rect.bottom > self.bounds.bottom:
            self.rect.top = 0
        elif self.rect.top < 0:
            self.rect.bottom = self.bounds.bottom

    def change_direction(self, direction: Direction):
        if not self.facing == direction and not direction.opposite(self.facing):
            self.facing = direction


class SnakeBody(Sprite):
    def __init__(
        self,
        size: int,
        position: Tuple[int, int],
        colour: str = "white",
    ) -> None:
        super().__init__()
        self.image = Surface((size, size))
        self.image.fill(Color(colour))
        self.rect = self.image.get_rect()
        self.rect.center = position


class Snake(RenderUpdates):
    def __init__(self, game: Game) -> None:
        self.segment_size = game.segment_size
        self.colours = itertools.cycle(["aquamarine1", "aquamarine3"])

        self.head = SnakeHead(
            size=self.segment_size,
            position=game.rect.center,
            facing=Direction.RIGHT,
            bounds=game.rect,
        )

        neck = [
            SnakeBody(
                size=self.segment_size,
                position=game.rect.center,
                colour=next(self.colours),
            )
            for _ in range(2)
        ]

        super().__init__(*[self.head, *neck])

        self.body = Group()
        self.tail = neck[-1]

    def update(self, *args: Any, **kwargs: Any) -> None:
        self.head.update()

        # Snake body sprites don't update themselves. We update them here.
        segments = self.sprites()
        for i in range(len(segments) - 1, 0, -1):
            # Current sprite takes the position of the previous sprite.
            segments[i].rect.center = segments[i - 1].rect.center

    def change_direction(self, direction: Direction):
        self.head.change_direction(direction)

    def grow(self):
        tail = SnakeBody(
            size=self.segment_size,
            position=self.tail.rect.center,
            colour=next(self.colours),
        )
        self.tail = tail
        self.add(self.tail)
        self.body.add(self.tail)


class SnakeFood(Sprite):
    def __init__(self, game: Game, size: int, *groups: AbstractGroup) -> None:
        super().__init__(*groups)
        self.image = Surface((size, size))
        self.image.fill(Color("red"))
        self.rect = self.image.get_rect()

        self.rect.topleft = (
            random.randint(0, game.rect.width),
            random.randint(0, game.rect.height),
        )

        self.rect.clamp_ip(game.rect)

        # XXX: This approach to random food placement might end badly if the
        # snake is very large.
        while pg.sprite.spritecollideany(self, game.snake):
            self.rect.topleft = (
                random.randint(0, game.rect.width),
                random.randint(0, game.rect.height),
            )

            self.rect.clamp_ip(game.rect)


class Game:
    def __init__(self) -> None:
        self.rect = Rect(0, 0, 640, 480)
        self.background = Surface(self.rect.size)
        self.background.fill(Color("black"))

        self.score = 0
        self.framerate = 16

        self.segment_size = 10
        self.snake = Snake(self)
        self.food_group = RenderUpdates(SnakeFood(game=self, size=self.segment_size))

        pg.init()

    def _init_display(self) -> Surface:
        bestdepth = pg.display.mode_ok(self.rect.size, 0, 32)
        screen = pg.display.set_mode(self.rect.size, 0, bestdepth)

        pg.display.set_caption("Snake")
        pg.mouse.set_visible(False)

        screen.blit(self.background, (0, 0))
        pg.display.flip()

        return screen

    def draw(self, screen: Surface):
        dirty = self.snake.draw(screen)
        pg.display.update(dirty)

        dirty = self.food_group.draw(screen)
        pg.display.update(dirty)

    def update(self, screen):
        self.food_group.clear(screen, self.background)
        self.food_group.update()
        self.snake.clear(screen, self.background)
        self.snake.update()

    def main(self) -> int:
        screen = self._init_display()
        clock = pg.time.Clock()

        while self.snake.head.alive():
            for event in pg.event.get():
                if event.type == pg.QUIT or (
                    event.type == pg.KEYDOWN and event.key in (pg.K_ESCAPE, pg.K_q)
                ):
                    return self.score

            # Change direction using the arrow keys.
            keystate = pg.key.get_pressed()

            if keystate[pg.K_RIGHT]:
                self.snake.change_direction(Direction.RIGHT)
            elif keystate[pg.K_LEFT]:
                self.snake.change_direction(Direction.LEFT)
            elif keystate[pg.K_UP]:
                self.snake.change_direction(Direction.UP)
            elif keystate[pg.K_DOWN]:
                self.snake.change_direction(Direction.DOWN)

            # Detect collisions after update.
            self.update(screen)

            # Snake eats food.
            for food in pg.sprite.spritecollide(
                self.snake.head, self.food_group, dokill=False
            ):
                food.kill()
                self.snake.grow()
                self.score += 1

                # Increase framerate to speed up gameplay.
                if self.score % 5 == 0:
                    self.framerate += 1

                self.food_group.add(SnakeFood(self, self.segment_size))

            # Snake hit its own tail.
            if pg.sprite.spritecollideany(self.snake.head, self.snake.body):
                self.snake.head.kill()

            self.draw(screen)
            clock.tick(self.framerate)

        return self.score


if __name__ == "__main__":
    game = Game()
    score = game.main()
    print(score)
