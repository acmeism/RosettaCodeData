import math

import pygame
from pygame.locals import *

pygame.init()
screen = pygame.display.set_mode((1024, 600))

pygame.display.set_caption("Polyspiral")

incr = 0

running = True

while running:
	pygame.time.Clock().tick(60)
	for event in pygame.event.get():
		if event.type==QUIT:
			running = False
			break

	incr = (incr + 0.05) % 360
	x1 = pygame.display.Info().current_w / 2
	y1 = pygame.display.Info().current_h / 2
	length = 5
	angle = incr

	screen.fill((255,255,255))

	for i in range(1,151):
		x2 = x1 + math.cos(angle) * length
		y2 = y1 + math.sin(angle) * length
		pygame.draw.line(screen, (255,0,0), (x1, y1), (x2, y2), 1)
		# pygame.draw.aaline(screen, (255,0,0), (x1, y1), (x2, y2)) # Anti-Aliased
		x1, y1 = x2, y2
		length += 3
		angle = (angle + incr) % 360

	pygame.display.flip()
