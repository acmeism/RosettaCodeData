# Author: Gal Zsolt (CalmoSoft)
load "libsdl.ring"

# Screen settings
SCREEN_WIDTH  = 800
SCREEN_HEIGHT = 800
FPS           = 60

# Celestial bodies: [Name, Distance, Speed, Size, Current_Angle, R, G, B]
planets = [
    ["Moon",       70,  0.05,  6,  0, 200, 200, 200],
    ["Mercury",   120,  0.03,  5,  0, 150, 150, 150],
    ["Venus",     170,  0.02,  9,  0, 255, 200,  0],
    ["Sun",       230,  0.015, 18, 0, 255, 150,  0],
    ["Mars",      300,  0.01,  7,  0, 255,  50,  0],
    ["Jupiter",   360,  0.007, 15, 0, 200, 150, 100]
]

# Exit button settings
BTN_X = 20
BTN_Y = 20
BTN_W = 40
BTN_H = 40

func main
    sdl_init(SDL_INIT_EVERYTHING)
    win = sdl_createwindow("Geocentric Model - CalmoSoft", 100, 100, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN)
    ren = sdl_createrenderer(win, -1, SDL_RENDERER_ACCELERATED)

    # CONSOLE OUTPUT: Simplified Planet and Color list
    see "--- Planet Colors ---" + nl
    for p in planets
        colorName = ""
        r = p[6] g = p[7] b = p[8]

        if r > 200 and g > 180 and b = 0 colorName = "Yellow"
        but r > 200 and g > 100 and b = 0 colorName = "Orange"
        but r > 200 and g < 100 and b = 0 colorName = "Red"
        but r = g and g = b and r > 180 colorName = "Light Grey"
        but r = g and g = b and r > 100 colorName = "Grey"
        else colorName = "Brown"
        ok

        see p[1] + ": " + colorName + nl
    next
    see "----------------------" + nl

    event = sdl_new_sdl_event()

    while true
        while sdl_pollevent(event)
            type = sdl_get_sdl_event_type(event)
            if type = SDL_QUIT return ok
            if type = SDL_KEYDOWN
                if sdl_get_sdl_event_key_keysym_sym(event) = SDLK_ESCAPE return ok
            ok
            if type = SDL_MOUSEBUTTONDOWN
                mx = sdl_get_sdl_event_button_x(event)
                my = sdl_get_sdl_event_button_y(event)
                if mx >= BTN_X and mx <= (BTN_X + BTN_W) and
                   my >= BTN_Y and my <= (BTN_Y + BTN_H)
                    return
                ok
            ok
        end

        # Background
        sdl_setrenderdrawcolor(ren, 5, 5, 20, 255)
        sdl_renderclear(ren)

        cx = SCREEN_WIDTH / 2
        cy = SCREEN_HEIGHT / 2

        # EXIT BUTTON (Red square + White X)
        sdl_setrenderdrawcolor(ren, 200, 0, 0, 255)
        rect_btn = sdl_new_sdl_rect()
        sdl_set_sdl_rect_x(rect_btn, BTN_X)
        sdl_set_sdl_rect_y(rect_btn, BTN_Y)
        sdl_set_sdl_rect_w(rect_btn, BTN_W)
        sdl_set_sdl_rect_h(rect_btn, BTN_H)
        sdl_renderfillrect(ren, rect_btn)

        sdl_setrenderdrawcolor(ren, 255, 255, 255, 255)
        sdl_renderdrawline(ren, BTN_X+10, BTN_Y+10, BTN_X+BTN_W-10, BTN_Y+BTN_H-10)
        sdl_renderdrawline(ren, BTN_X+BTN_W-10, BTN_Y+10, BTN_X+10, BTN_Y+BTN_H-10)

        # EARTH (Center)
        drawFilledCircle(ren, cx, cy, 20, 0, 100, 255)

        # ORBITS AND PLANETS
        for i = 1 to len(planets)
            planets[i][5] += planets[i][3] # Update angle
            p = planets[i]
            drawOrbit(ren, cx, cy, p[2])
            px = cx + cos(p[5]) * p[2]
            py = cy + sin(p[5]) * p[2]
            drawFilledCircle(ren, px, py, p[4], p[6], p[7], p[8])
        next

        sdl_renderpresent(ren)
        sdl_delay(1000 / FPS)
    end

    sdl_destroyrenderer(ren)
    sdl_destroywindow(win)
    sdl_quit()

func drawFilledCircle renderer, x, y, radius, r, g, b
    sdl_setrenderdrawcolor(renderer, r, g, b, 255)
    for w = -radius to radius
        for h = -radius to radius
            if (w*w + h*h) <= (radius*radius)
                sdl_renderdrawpoint(renderer, x + w, y + h)
            ok
        next
    next

func drawOrbit renderer, cx, cy, r
    sdl_setrenderdrawcolor(renderer, 60, 60, 60, 255)
    for i = 0 to 360 step 5
        rad = i * (3.14159 / 180)
        ox = cx + cos(rad) * r
        oy = cy + sin(rad) * r
        sdl_renderdrawpoint(renderer, ox, oy)
    next
