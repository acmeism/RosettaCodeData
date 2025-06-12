import pygame
import sys

GLOBAL_WINDOW_SIZE = (640, 480)
COLOURS = (
    (0, 0, 0),
    (255, 0, 0),
    (0, 255, 0),
    (0, 0, 255),
    (255, 0, 255),
    (0, 255, 255),
    (255, 255, 0),
    (255, 255, 255)
)

def drawColouredStripes(surface):
    stripeWidth = surface.get_width() // 8
    for i, col in enumerate(COLOURS):
        pygame.draw.rect(surface, col, pygame.Rect(i*stripeWidth, 0, stripeWidth, surface.get_height()))

pygame.init()

if len(sys.argv) == 3:
    newWindowSize = (int(sys.argv[1]), int(sys.argv[2]))
    screen = pygame.display.set_mode(newWindowSize)
else:
    screen = pygame.display.set_mode(GLOBAL_WINDOW_SIZE)

running = True

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    drawColouredStripes(screen)

    pygame.display.flip()

pygame.quit()
