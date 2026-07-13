load "gamelib.ring"

# Configuration constants
WIDTH  = 800
HEIGHT = 600
STEPS  = 12  # Number of iterations for the fractal generation

al_init()
al_install_keyboard()
al_init_primitives_addon()

# Create the display window
display = al_create_display(WIDTH, HEIGHT)
al_set_window_title(display, "Dragon Curve in Ring")

# Event queue to handle closing the application
event_queue = al_create_event_queue()
al_register_event_source(event_queue, al_get_display_event_source(display))
al_register_event_source(event_queue, al_get_keyboard_event_source())

# Main logic to generate the dragon curve sequence
# 1 represents a right turn (90 degrees), -1 represents a left turn
turns = [1]

# Generate the sequence of turns using string/array folding logic
for i = 2 to STEPS
    # To get the next iteration: copy current, add a Right turn,
    # then add the reversed and inverted copy of the current sequence
    next_turns = turns
    add(next_turns, 1)

    # Invert and reverse the existing turns
    for j = len(turns) to 1 step -1
        add(next_turns, -turns[j])
    next

    turns = next_turns
next

# Clear screen with a dark blue/gray background
al_clear_to_color(al_map_rgb(20, 24, 33))

# Initial parameters for drawing
x = 250       # Starting X coordinate
y = 400       # Starting Y coordinate
length = 4    # Length of each line segment
dir = 0       # Initial direction: 0=Right, 1=Up, 2=Left, 3=Down

# Color definition for the fractal lines (Bright Cyan)
line_color = al_map_rgb(0, 255, 200)

# Draw the initial starting segment
next_x = x + length
next_y = y
al_draw_line(x, y, next_x, next_y, line_color, 1)
x = next_x
y = next_y

# Iterate through the generated turn sequence and draw lines
for move in turns
    # Update direction based on the turn value (1 or -1)
    dir = (dir + move) % 4
    if dir < 0 dir += 4 ok  # Inline 'ok' handles this condition completely

    # Calculate new coordinates based on the current direction
    # This single structure opens with 'if', chains with 'but', and safely closes with 'ok'
    if dir = 0
        next_x = x + length
        next_y = y
    but dir = 1
        next_x = x
        next_y = y - length
    but dir = 2
        next_x = x - length
        next_y = y
    but dir = 3
        next_x = x
        next_y = y + length
    ok  # This closes the entire multi-branch direction structure

    # Draw the line segment to the screen
    al_draw_line(x, y, next_x, next_y, line_color, 1)

    # Move the current cursor position to the end of the line
    x = next_x
    y = next_y
next

# Update the screen to display the completed fractal
al_flip_display()

# Main event loop: keep window open until ESC is pressed or window is closed
event = al_new_allegro_event()
while true
    al_wait_for_event(event_queue, event)
    type = al_get_allegro_event_type(event)

    # Exit condition: close button clicked
    if type = ALLEGRO_EVENT_DISPLAY_CLOSE
        exit
    ok

    # Exit condition: Escape key pressed
    if type = ALLEGRO_EVENT_KEY_DOWN
        if al_get_allegro_event_keyboard_keycode(event) = ALLEGRO_KEY_ESCAPE
            exit
        ok
    ok
end

# Clean up memory resources before closing
al_destroy_display(display)
al_destroy_event_queue(event_queue)
