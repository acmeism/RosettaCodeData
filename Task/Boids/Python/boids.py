import math
import pygame
import random

WIDTH, HEIGHT = 1000, 800

def rotate_triangle(center: tuple[int, int], scale: int, angle: float):
    v_center = pygame.math.Vector2(center)

    points = [(-0.5, -0.866), (-0.5, 0.866), (2.0, 0.0)]
    rotated_point = [pygame.math.Vector2(p).rotate(angle) for p in points]

    triangle_points = [(v_center + p * scale) for p in rotated_point]
    return triangle_points


class Boid:
    def __init__(self, x: int, y: int, r: float, min_speed=5, max_speed=10):
        self.x = x
        self.y = y
        self.min_speed = min_speed
        self.speed = min_speed
        self.max_speed = max_speed
        self.r = r
        self.turn_rate = 1
        self.angle = random.randint(0, 360)

    def draw(self, surface: pygame.Surface):
        points = rotate_triangle((self.x, self.y), 10, self.angle)
        pygame.draw.polygon(surface, (255, 255, 255), points)

    def move(self):
        angle_rad = math.radians(self.angle)
        self.x = (self.x + math.cos(angle_rad) * self.speed) % WIDTH
        self.y = (self.y + math.sin(angle_rad) * self.speed) % HEIGHT

    def get_peripheral_rect(self):
        w = h = self.r * 2
        return pygame.Rect(self.x - w // 2, self.y - h // 2, w, h)

    def is_neighbour(self, b: "Boid"):
        return b.get_peripheral_rect().colliderect(self.get_peripheral_rect())

    def calculate_steer(self, boids: list["Boid"]):
        neighbours = [b for b in boids if b.is_neighbour(self)]

        if len(neighbours) > 0:
            sumation = 0

            for n in neighbours:
                sumation += n.angle

            self.angle = sumation / len(neighbours)

            center_y = sum(n.get_peripheral_rect().centerx for n in neighbours) / len(
                neighbours
            )
            center_x = sum(n.get_peripheral_rect().centery for n in neighbours) / len(
                neighbours
            )

            desired_angle = math.degrees(
                math.atan2(center_y - self.y, center_x - self.x)
            )

            angle_diff = (desired_angle - self.angle + 180) % 360 - 180

            if angle_diff <= 0:
                self.angle += max(-self.turn_rate * 0.5, angle_diff)
            else:
                self.angle += min(angle_diff, self.turn_rate * 0.5)

            self.speed = math.sqrt(self.x * self.x + self.y * self.y)
            self.speed = max(self.speed % self.max_speed, self.min_speed)


def main():
    pygame.init()
    pygame.display.set_caption("Boids")

    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    clock = pygame.time.Clock()

    running = True

    boids = [
        Boid(random.randint(0, WIDTH), random.randint(0, HEIGHT), 15) for _ in range(15)
    ]

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        screen.fill((0, 0, 0))

        for boid in boids:
            boid.draw(screen)
            boid.move()
            boid.calculate_steer(boids)

        pygame.display.flip()
        clock.tick(60)

    pygame.quit()


if __name__ == "__main__":
    main()
