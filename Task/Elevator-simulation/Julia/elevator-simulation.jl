using Gtk4
using Cairo
using Colors

# Constants
const WINDOW_WIDTH = 800
const WINDOW_HEIGHT = 700
const CD_DARKER_GREY = RGB(56/255, 56/255, 56/255)
const CD_LIGHTER_ORANGE = RGB(255/255, 165/255, 0/255)
const CD_PALE_BLUE = RGB(152/255, 197/255, 218/255)
const CD_MEDIUM_BLUE = RGB(117/255, 158/255, 180/255)

""" Elevator Button """
mutable struct Button
    x::Float64
    y::Float64
    text::String
    radius::Float64
    Button() = new(0.0, 0.0, "", 0.0)
    Button(x::Real, y::Real, txt::String, r::Real) = new(Float64(x), Float64(y), txt, Float64(r))
end

""" Panel struct """
mutable struct Panel
    x::Float64
    y::Float64
    width::Float64
    height::Float64
    Panel() = new(0.0, 0.0, 0.0, 0.0)
    Panel(x::Real, y::Real, w::Real, h::Real) = new(Float64(x), Float64(y), Float64(w), Float64(h))
end

""" State variables """
mutable struct ElevatorState
    curFloor::Int
    waitSign::Int
    doorOpen::Bool
    actionCount::Int
    actions::Vector{String}
    drawing_function::Function
    ElevatorState() = new(0, 0, false, 0, fill("", 100), () -> nothing)
end

# Global elevator state
const elevator_state = ElevatorState()

# Initialize panels and buttons (same coordinates as original)
const panels = [
    Panel(195, 30, 45, 12),     # indicator
    Panel(380, 150, 50, 90),    # up/down
    Panel(380, 465, 100, 210),  # main
    Panel(625, 330, 75, 25),    # restart
    Panel(625, 530, 75, 25),     # exit
]

const buttons = [
    Button(380, 110, "^", 30),
    Button(380, 190, "v", 30),
    Button(335, 305, "5", 30),
    Button(420, 305, "6", 30),
    Button(335, 385, "3", 30),
    Button(420, 385, "4", 30),
    Button(335, 465, "1", 30),
    Button(420, 465, "2", 30),
    Button(380, 540, "GF", 30),
    Button(380, 630, "><", 30),
]

""" Reset the game state by randomizing the current floor, wait sign, and door status. """
function newGame!()
    elevator_state.curFloor = rand(0:6)
    elevator_state.waitSign = rand(0:6)
    elevator_state.doorOpen = rand(Bool)
    elevator_state.actionCount = 0
    fill!(elevator_state.actions, "")
end

""" Helper function to set Cairo context color from Colors.jl RGB type. """
function set_cairo_color(ctx, color::RGB)
    set_source_rgb(ctx, color.r, color.g, color.b)
end

""" Helper function to draw a filled rectangle with optional setting of color. """
function draw_rectangle(ctx, x, y, width, height, fill_color, stroke_color = nothing)
    rectangle(ctx, x - width, y - height, width * 2, height * 2)
    set_cairo_color(ctx, fill_color)
    fill_preserve(ctx)
    if stroke_color !== nothing
        set_cairo_color(ctx, stroke_color)
        set_line_width(ctx, 1.0)
    end
    stroke(ctx)
end

""" Helper function to draw a filled diamond with optional setting of color. """
function draw_diamond(ctx, x, y, width, height, fill_color, stroke_color = nothing)
    move_to(ctx, x, y - height / 2)
    line_to(ctx, x - width / 2, y)
    line_to(ctx, x, y + height / 2)
    line_to(ctx, x + width / 2, y)
    close_path(ctx)
    set_cairo_color(ctx, fill_color)
    fill_preserve(ctx)
    if stroke_color !== nothing
        set_cairo_color(ctx, stroke_color)
        set_line_width(ctx, 1.0)
    end
    stroke(ctx)
end

""" Helper function to draw a filled circle with optional setting of color. """
function draw_circle(ctx, x, y, radius, fill_color, stroke_color = nothing)
    arc(ctx, x, y, radius, 0, 2π)
    set_cairo_color(ctx, fill_color)
    fill_preserve(ctx)

    if stroke_color !== nothing
        set_cairo_color(ctx, stroke_color)
        set_line_width(ctx, 1.0)
    end
    stroke(ctx)
end

""" Helper function to draw text centered at given position. """
function draw_text(ctx, text, x, y, color, font_size = 24)
    set_cairo_color(ctx, color)
    select_font_face(ctx, "Arial", 0, 1)
    set_font_size(ctx, font_size)
    _, _, extents_width, extents_height = text_extents(ctx, text)
    move_to(ctx, x - extents_width / 2, y - extents_height / 2)
    show_text(ctx, text)
end

""" Main drawing function that renders the entire elevator scene. """
function draw_elevator_scene(ctx)
    # Set background
    set_cairo_color(ctx, CD_DARKER_GREY)
    paint(ctx)

    # Draw panels
    for panel in panels
        draw_rectangle(ctx, panel.x, panel.y, panel.width, panel.height,
            CD_LIGHTER_ORANGE, RGB(0, 0, 0))
    end

    # Draw panel labels
    draw_text(ctx, "Restart", panels[4].x, panels[4].y + 12, RGB(0, 0, 0), 16)
    draw_text(ctx, "Exit", panels[5].x, panels[5].y + 12, RGB(0, 0, 0), 16)

    # Floor indicator
    floor_text = elevator_state.curFloor == 0 ? "GF" : string(elevator_state.curFloor)
    draw_text(ctx, floor_text, panels[1].x, panels[1].y + 11, RGB(0, 0, 0), 16)

    # Draw elevator shaft and floors
    for i ∈ 6:-1:0
        floorY = 50 + (6 - i) * 90

        # Draw floor background
        draw_rectangle(ctx, 195, floorY + 40, 40, 40, RGB(1, 1, 1), RGB(0.5, 0.5, 0.5))

        # Draw floor number
        floor_num = i == 0 ? "GF" : string(i)
        draw_text(ctx, floor_num, 130, floorY + 35, RGB(1, 1, 1), 16)
    end

    # Elevator car position
    elevator_y = 50 + (6 - elevator_state.curFloor) * 90 + 40

    # Draw elevator car
    draw_rectangle(ctx, 195, elevator_y, 35, 35, CD_MEDIUM_BLUE)

    # Draw doors
    door_color = elevator_state.doorOpen ? CD_PALE_BLUE : CD_MEDIUM_BLUE
    draw_rectangle(ctx, 175, elevator_y, 10, 35, door_color)
    draw_rectangle(ctx, 215, elevator_y, 10, 35, door_color)

    # Draw wait sign
    if elevator_state.waitSign >= 0
        wait_y = 50 + (6 - elevator_state.waitSign) * 90 + 40
        draw_diamond(ctx, 193, wait_y, 75, 75, RGB(1, 1, 0), RGB(0, 0, 0))
        set_line_width(ctx, 2.0)
        draw_text(ctx, "WAIT", 194, wait_y + 14, RGB(0, 0, 0), 16)
        stroke(ctx)
    end

    # Draw buttons
    for button in buttons
        draw_circle(ctx, button.x, button.y, button.radius,
            RGB(0.75, 0.75, 0.75), RGB(0, 0, 0))
        stroke(ctx)
        draw_text(ctx, button.text, button.x - 2, button.y + (length(button.text) > 1 ? 25 : 35), RGB(0, 0, 0), length(button.text) > 1 ? 35 : 50)
        stroke(ctx)
    end
end

""" Processes actions from the global actions queue and updates elevator state. """
function processActions!()
    if elevator_state.actionCount > 0
        action = elevator_state.actions[1]
        elevator_state.actions[1:(end-1)] = elevator_state.actions[2:end]
        elevator_state.actions[end] = ""
        elevator_state.actionCount -= 1

        if action == "GF"
            if elevator_state.curFloor > 0
                elevator_state.curFloor -= 1
                elevator_state.doorOpen = false
            else
                elevator_state.doorOpen = true
            end
        elseif action in ["1", "2", "3", "4", "5", "6"]
            target_floor = parse(Int, action)
            # Simulate movement floor by floor
            while elevator_state.curFloor != target_floor
                if elevator_state.curFloor < target_floor
                    elevator_state.curFloor += 1
                else
                    elevator_state.curFloor -= 1
                end
                elevator_state.doorOpen = false
                elevator_state.drawing_function()
                sleep(0.5)
                # Check for wait sign
                if elevator_state.curFloor == elevator_state.waitSign
                    elevator_state.waitSign = -1
                    elevator_state.doorOpen = true
                    elevator_state.drawing_function()
                    sleep(1.5)
                    elevator_state.doorOpen = false
                    elevator_state.drawing_function()
                    sleep(0.5)
                end
            end
            elevator_state.doorOpen = true
        elseif action == "^"
            if elevator_state.curFloor < 6
                elevator_state.curFloor += 1
                elevator_state.doorOpen = false
            end
        elseif action == "v"
            if elevator_state.curFloor > 0
                elevator_state.curFloor -= 1
                elevator_state.doorOpen = false
            end
        elseif action == "><"
            elevator_state.doorOpen = !elevator_state.doorOpen
            sleep(1)
        end
    end
end

""" Handle mouse clicks on buttons and panels. """
function handle_button_click(x, y)
    # Check for button clicks
    for button in buttons
        dist_sq = (x - button.x)^2 + (y - button.y)^2
        if dist_sq <= button.radius^2
            elevator_state.actions[elevator_state.actionCount+1] = button.text
            elevator_state.actionCount += 1
            return true
        end
    end

    # Check for panel clicks (Restart/Exit)
    if panels[4].x - panels[4].width <= x <= panels[4].x + panels[4].width &&
       panels[4].y - panels[4].height <= y <= panels[4].y + panels[4].height
        newGame!()
        return true
    elseif panels[5].x - panels[5].width <= x <= panels[5].x + panels[5].width &&
       panels[5].y - panels[5].height <= y <= panels[5].y + panels[5].height
        exit()
    end
    return false
end


""" Set up and run Gtk4 window and canvas. """
function main()
    # Create application
    app = GtkWindow("Elevator Simulation", WINDOW_WIDTH, WINDOW_HEIGHT)
    canvas = GtkCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)
    app[] = canvas
    @guarded draw(canvas) do widget
        ctx = getgc(canvas)
        draw_elevator_scene(ctx)
    end
    elevator_state.drawing_function = () -> draw(canvas)

    # Set up mouse click handling
    gesture = GtkGestureClick(canvas)

    signal_connect(gesture, "pressed") do gesture, n_press, x, y
        handle_button_click(x, y)
    end

    # Set up key press handling
    key_controller = GtkEventControllerKey()
    signal_connect(key_controller, "key-pressed") do controller, keyval, keycode, state
        if keyval == Gdk.KEY_Escape
            close(window)
            return true
        end
        return false
    end

    running = true
    signal_connect(app, "destroy") do widget
        running = false
    end
    newGame!()
    show(app)
    while running
        processActions!()
        elevator_state.drawing_function()
        sleep(0.1)
    end
end

# Run the application
main()
