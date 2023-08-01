require 'io/console'

def c (method, *args) # to avoid repeating sleeps
    STDOUT.send(method, *args)
    sleep 1
end

x, y = STDOUT.winsize
c(:clear_screen)
c(:cursor_right, 1)
c(:cursor_down, 1)
c(:cursor_left, 1)
c(:cursor_up, 1)
c(:goto_column, y)
c(:goto_column, 0)
c(:goto, 0, y)
c(:goto, x, 0)
