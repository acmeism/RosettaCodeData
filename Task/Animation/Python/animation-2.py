import pygame, sys
from pygame.locals import *
pygame.init()

YSIZE = 40
XSIZE = 150

TEXT = "Hello World! "
FONTSIZE = 32

LEFT = False
RIGHT = True

DIR = RIGHT

TIMETICK = 180
TICK = USEREVENT + 2

TEXTBOX = pygame.Rect(10,10,XSIZE,YSIZE)

pygame.time.set_timer(TICK, TIMETICK)

window = pygame.display.set_mode((XSIZE, YSIZE))
pygame.display.set_caption("Animation")

font = pygame.font.SysFont(None, FONTSIZE)
screen = pygame.display.get_surface()

def rotate():
    index = DIR and -1 or 1
    global TEXT
    TEXT = TEXT[index:]+TEXT[:index]

def click(position):
    if TEXTBOX.collidepoint(position):
        global DIR
        DIR = not DIR

def draw():
    surface = font.render(TEXT, True, (255,255,255), (0,0,0))
    global TEXTBOX
    TEXTBOX = screen.blit(surface, TEXTBOX)

def input(event):
    if event.type == QUIT:
        sys.exit(0)
    elif event.type == MOUSEBUTTONDOWN:
        click(event.pos)
    elif event.type == TICK:
        draw()
        rotate()

while True:
    input(pygame.event.wait())
    pygame.display.flip()
