import pygame as pg

def segment_intersection(a, b, c, d):
    """ returns a pygame.Vector2 or None if there is no intersection """
    ab, cd, ac = a - b, c - d, a - c
    if not (denom:= ab.x * cd.y - ab.y * cd.x):
        return

    t = (ac.x * cd.y - ac.y * cd.x) / denom
    u = -(ab.x * ac.y - ab.y * ac.x) / denom
    if 0 <= t <= 1 and 0 <= u <= 1:
        return a.lerp(b, t)


if __name__ == '__main__':
    a,b = pg.Vector2(4,0), pg.Vector2(6,10)  # try (4, 0), (6, 4)
    c,d = pg.Vector2(0,3), pg.Vector2(10,7)  # for non intersecting test
    pt = segment_intersection(a, b, c, d)
    print(pt)
