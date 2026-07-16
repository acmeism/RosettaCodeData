import pygame
import random, sys

START_LEVEL = 1
FPS = 60
MUSIC = False

piece_data = """
     *  x  *     *  x  *
     *  x  *     *  x  *
xxxx *  x  *xxxx *  x  *
     *  x  *     *  x  *
     *     *     *     *
************************
     *     *     *     *
 xx  * xx  * xx  * xx  *
 xx  * xx  * xx  * xx  *
     *     *     *     *
     *     *     *     *
************************
     *     *     *     *
     *  x  *  x  *  x  *
 xxx * xx  * xxx *  xx *
  x  *  x  *     *  x  *
     *     *     *     *
************************
     *     *     *     *
     * xx  *   x *  x  *
 xxx *  x  * xxx *  x  *
 x   *  x  *     *  xx *
     *     *     *     *
************************
     *     *     *     *
     *  x  * x   *  xx *
 xxx *  x  * xxx *  x  *
   x * xx  *     *  x  *
     *     *     *     *
************************
     *     *     *     *
     * x   *     * x   *
  xx * xx  *  xx * xx  *
 xx  *  x  * xx  *  x  *
     *     *     *     *
************************
     *     *     *     *
     *  x  *     *  x  *
 xx  * xx  * xx  * xx  *
  xx * x   *  xx * x   *
     *     *     *     *
************************""".splitlines()[1:]

piece_names = "IOTJLZS"

colors = (
    (0, 178, 239),
    (255, 219, 33),
    (144, 38, 140),
    (0, 121, 193),
    (246, 150, 45),
    (236, 51, 43),
    (131, 196, 76),
)

colors_locked = []
for r, g, b in colors:
    colors_locked.append((0.7 * r, 0.7 * g, 0.7 * b))

clear_scores = 100, 300, 500, 800  # row clearing scores
game = [[0] * 10 for y in range(20)]

if len(sys.argv) > 1:
    garbage = int(sys.argv[1])
    glist = list(range(8)) + 7 * [0]
    for l in range(garbage):
        for x in range(10):
            game[l][x] = random.choice(glist)


def add_to_bag():
    "Seven-bag randomizer"
    b = list(range(7))
    random.shuffle(b)
    return b


class PyTris:
    def __init__(self):
        pygame.init()
        pygame.key.set_repeat(267, 100)
        self.res = 900, 900
        self.screen = pygame.display.set_mode(self.res, pygame.RESIZABLE)
        pygame.display.set_caption("PyTris")
        self.clock = pygame.time.Clock()
        self.dazz = pygame.Surface((10, 20))
        self.preview = pygame.Surface((5, 30))
        self.bg_col = 22, 30, 40
        if MUSIC:
            self.music = pygame.mixer.Sound("music.wav")
            self.music.play(loops = -1)
        self.play_music = True
        self.paused = False
        self.dir = 0
        self.piece = -1
        self.lines = 0
        self.score = 0
        self.dirty = True  # redraw screen?
        self.level = START_LEVEL
        self.bag = add_to_bag()
        self.new_piece()

    def new_piece(self):
        "Pick a new piece"
        if self.piece == -1:
            self.piece = random.randint(0, 4)  # do not start with S or Z as first piece
        else:
            self.piece = self.bag.pop(0)
            if len(self.bag) < 7:
                self.bag += add_to_bag()
                # print(self.bag)
        self.xpos = 5
        if self.piece < 2:  # O or I
            self.ypos = 19
        else:
            self.ypos = 18
        self.dir = 0
        self.grav_count = 0
        self.fast = False
        self.dropscore = 0
        if not self.test_shape(self.xpos, self.ypos, self.dir):
            print("Game over")
            print("Final score:")
            print(f"LINES: {self.lines} SCORE: {self.score} LEVEL: {self.level}")
            self.paused = True
        self.title()
        self.make_grid()
        self.dirty = True

        # update preview
        self.preview.fill(self.bg_col)
        for p in range(6):
            for yi in range(5):
                for xi in range(5):
                    t = piece_data[self.bag[p] * 6 + yi][xi]
                    if t == "x":
                        self.preview.set_at((xi, 4 - yi + 5 * p), colors[self.bag[p]])

    def test_shape(self, xp, yp, direc):
        "Try to add current shape at xy, yp; return True if allowed"
        for yi in range(5):
            for xi in range(5):
                t = piece_data[self.piece * 6 + yi][direc * 6 + xi]
                if t == "x":
                    x2, y2 = xp - 2 + xi, yp - 2 + yi
                    if x2 < 0 or x2 > 9 or y2 < 0:
                        return False  # out of bounds
                    if y2 < 20 and game[y2][x2]:  # collision with another piece
                        return False
        return True

    def events(self):
        "Handle player input"
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.running = False
            if event.type == pygame.VIDEORESIZE:
                self.res = event.w, event.h
                self.screen = pygame.display.set_mode(self.res, pygame.RESIZABLE)
                self.make_grid()
                self.dirty = True
            if event.type == pygame.KEYDOWN and event.key == pygame.K_p:
                self.paused = not self.paused
            if event.type == pygame.KEYDOWN and event.key == pygame.K_m:
                self.play_music = not self.play_music
                if not self.play_music:
                    pygame.mixer.pause()
                else:
                    pygame.mixer.unpause()

            if event.type == pygame.KEYDOWN and event.key == pygame.K_RIGHT:
                if self.test_shape(self.xpos + 1, self.ypos, self.dir):
                    self.xpos += 1
                    self.dirty = True
            if event.type == pygame.KEYDOWN and event.key == pygame.K_LEFT:
                if self.test_shape(self.xpos - 1, self.ypos, self.dir):
                    self.xpos -= 1
                    self.dirty = True
            if event.type == pygame.KEYDOWN and event.key == pygame.K_UP:
                newdir = (self.dir - 1) % 4
                if self.test_shape(self.xpos, self.ypos, newdir):
                    self.dir = newdir
                    self.dirty = True
            if event.type == pygame.KEYDOWN and event.key in (pygame.K_LCTRL, pygame.K_RCTRL):
                newdir = (self.dir + 1) % 4
                if self.test_shape(self.xpos, self.ypos, newdir):
                    self.dir = newdir
                    self.dirty = True
            if event.type == pygame.KEYDOWN and event.key == pygame.K_DOWN:
                self.fast = True
            if event.type == pygame.KEYUP and event.key == pygame.K_DOWN:
                self.fast = False
            if event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE:
                self.grav_count = 100000  # force piece move now
                for i in range(1, 100):
                    if not self.test_shape(self.xpos, self.ypos - i, self.dir):
                        self.ypos -= i - 1
                        break
                    else:
                        self.dropscore += 2

    def run(self):
        "Run and limit to frame rate (FPS)"
        self.running = True
        while self.running:
            self.clock.tick(FPS)
            self.events()
            self.update()
        pygame.quit()

    def title(self):
        "Set window title"
        pygame.display.set_caption(
            f"PyTris (LINES: {self.lines} SCORE: {self.score}"
            + f" LEVEL: {self.level} NEXT: {piece_names[self.bag[0]]})"
        )

    def make_grid(self):
        "Make grid overlay"
        self.grid = pygame.Surface((self.res[1] // 2, self.res[1]))
        self.grid.fill((0, 0, 0))
        c = self.res[1] / 20
        b = 2
        for y in range(20):
            for x in range(10):
                pygame.draw.rect(
                    self.grid, (255, 0, 0), [x * c + b, y * c + b, c - 2 * b, c - 2 * b]
                )
        self.grid.set_colorkey((255, 0, 0))

    def update(self):
        "Main loop"
        if self.paused:
            self.screen.blit(
                self.out, (self.res[0] // 2 - self.out.get_width() // 2, 0)
            )
            self.screen.blit(
                self.grid, (self.res[0] // 2 - self.out.get_width() // 2, 0)
            )
            pygame.display.flip()
            return
        if self.fast:
            self.grav_count += 8
        else:
            self.grav_count += 1
        wait = FPS * (0.8 - ((self.level - 1) * 0.007))**(self.level - 1)
        if self.grav_count > wait:
            self.grav_count = 0
            if self.fast:
                self.dropscore += 1
            if self.test_shape(self.xpos, self.ypos - 1, self.dir):
                self.ypos -= 1
                self.dirty = True
            else:  # lock down piece
                for yi in range(5):
                    for xi in range(5):
                        t = piece_data[self.piece * 6 + yi][self.dir * 6 + xi]
                        if t == "x":
                            x2, y2 = self.xpos - 2 + xi, self.ypos - 2 + yi
                            if 0 <= x2 <= 9 and 0 <= y2 <= 19:
                                game[y2][x2] = self.piece + 1
                self.score += self.dropscore
                self.dropscore = 0
                self.title()
                # check for completed rows
                yi = 0
                total_cleared = 0
                while yi < 19:
                    lc = 0
                    for xi in range(10):
                        if game[yi][xi]:
                            lc += 1
                    if lc == 10:
                        self.lines += 1
                        total_cleared += 1
                        self.title()
                        for y2 in range(yi, 19):
                            for x2 in range(10):
                                game[y2][x2] = game[y2 + 1][x2]
                        yi -= 1
                    yi += 1
                if total_cleared > 0:
                    self.score += self.level * clear_scores[total_cleared - 1]
                    self.level = min(self.lines // 10 + START_LEVEL, 15)
                    self.title()
                self.new_piece()

        if self.dirty:
            self.dirty = False
            self.dazz.fill((0, 0, 0))
            for yi in range(5):
                for xi in range(5):
                    t = piece_data[self.piece * 6 + yi][self.dir * 6 + xi]
                    if t == "x":
                        x2, y2 = self.xpos - 2 + xi, self.ypos - 2 + yi
                        self.dazz.set_at((x2, 19 - y2), colors[self.piece])
            for yi in range(20):
                for xi in range(10):
                    if game[yi][xi]:
                        self.dazz.set_at((xi, 19 - yi), colors_locked[game[yi][xi] - 1])

            scale_res = self.res[1] // 2, self.res[1]
            self.out = pygame.transform.scale(self.dazz, (scale_res))

        self.screen.fill(self.bg_col)
        self.screen.blit(self.out, (self.res[0] // 2 - self.out.get_width() // 2, 0))
        self.screen.blit(self.grid, (self.res[0] // 2 - self.out.get_width() // 2, 0))
        preview_big = pygame.transform.scale(self.preview, (self.res[1] // 6,
                                                            self.res[1]))
        self.screen.blit(preview_big, (0, 0))
        pygame.display.flip()


c = PyTris()
c.run()
