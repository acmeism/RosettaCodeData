# Author: Gal Zsolt (CalmoSoft)
load "libsdl.ring"
load "stdlibcore.ring"

# Settings
screen_w = 640
screen_h = 480
xp = screen_w/2
yp = screen_h/2
size = 200
pi = 3.14159265

sdl_init(SDL_INIT_EVERYTHING)
window = sdl_createwindow("Analog Clock - CalmoSoft", 100, 100, screen_w, screen_h, SDL_WINDOW_SHOWN)
render = sdl_createrenderer(window, -1, SDL_RENDERER_ACCELERATED)
ev = sdl_new_sdl_event()

while true
    # Event handling
    sdl_pollevent(ev)
    if sdl_get_sdl_event_type(ev) = SDL_QUIT exit ok

    # Get system time
    t = time()
    h = 0 + substr(t,1,2)
    m = 0 + substr(t,4,2)
    s = 0 + substr(t,7,2)

    # Clear background (Black)
    sdl_setrenderdrawcolor(render, 0, 0, 0, 255)
    sdl_renderclear(render)

    # Draw the clock components
    draw_clock(render, xp, yp, size, h, m, s, pi)

    sdl_renderpresent(render)
    sdl_delay(100)
end

# Clean up
sdl_destroyrenderer(render)
sdl_destroywindow(window)
sdl_quit()

func draw_clock render, x, y, r, h, m, s, pi
    # 1. Draw Clock Face (White circle outline)
    sdl_setrenderdrawcolor(render, 255, 255, 255, 255)
    for i = 0 to 360 step 1
        angle = i * pi / 180
        sdl_renderdrawpoint(render, x + r * cos(angle), y + r * sin(angle))
    next

    # 2. Draw Hour Markers (Ticks)
    sdl_setrenderdrawcolor(render, 255, 255, 255, 255)
    for i = 1 to 12
        angle = i * 30 * pi / 180
        x1 = x + r * 0.95 * sin(angle)
        y1 = y - r * 0.95 * cos(angle)
        x2 = x + r * 0.85 * sin(angle)
        y2 = y - r * 0.85 * cos(angle)
        sdl_renderdrawline(render, x1, y1, x2, y2)
    next

    # Calculate angles for hands
    s_angle = (s / 60) * 2 * pi
    m_angle = ((m + s/60) / 60) * 2 * pi
    h_angle = ((h % 12 + m/60) / 12) * 2 * pi

    # 3. Draw Hands (Thickened)

    # Hour Hand (Green - thickest: 5px)
    sdl_setrenderdrawcolor(render, 0, 255, 0, 255)
    for i = -2 to 2
        sdl_renderdrawline(render, x+i, y+i, x + r*0.5*sin(h_angle)+i, y - r*0.5*cos(h_angle)+i)
    next

    # Minute Hand (Blue - medium: 3px)
    sdl_setrenderdrawcolor(render, 0, 100, 255, 255)
    for i = -1 to 1
        sdl_renderdrawline(render, x+i, y+i, x + r*0.8*sin(m_angle)+i, y - r*0.8*cos(m_angle)+i)
    next

    # Second Hand (Red - 2px)
    sdl_setrenderdrawcolor(render, 255, 0, 0, 255)
    for i = 0 to 1
        sdl_renderdrawline(render, x+i, y+i, x + r*0.9*sin(s_angle)+i, y - r*0.9*cos(s_angle)+i)
    next

    # 4. Center Cap (Axis)
    sdl_setrenderdrawcolor(render, 200, 200, 200, 255)
    for i = 0 to 360 step 10
        angle = i * pi / 180
        for radius = 0 to 5
            sdl_renderdrawpoint(render, x + radius * cos(angle), y + radius * sin(angle))
        next
    next
