using Gtk4
using Gtk4.GLib


""" App to create and initialize the GTK app object and set up the main window """
mutable struct AppState
    target_window::GtkWindow
    target_widget::GtkTextView
    target_buffer::GtkTextBuffer
    function AppState()
        window = GtkWindow("Keystroke Target Window")
        set_gtk_property!(window, :default_width, 800)
        set_gtk_property!(window, :default_height, 800)
        set_gtk_property!(window, :resizable, true)
        set_gtk_property!(window, :visible, true)
        set_gtk_property!(window, :title, "Keystroke Simulation Target")
        set_gtk_property!(window, :border_width, 10)
        set_gtk_property!(window, :destroy_with_parent, true)
        set_gtk_property!(window, :can_focus, true)
        buffer = GtkTextBuffer()
        set_gtk_property!(buffer, :text, "This is a target text area.\nSimulated keystrokes will appear here.\n\n")
        widget = GtkTextView(buffer)
        set_gtk_property!(widget, :can_focus, true)
        set_gtk_property!(widget, :editable, true)
        set_gtk_property!(widget, :cursor_visible, true)
        scrolled = GtkScrolledWindow()
        scrolled[] = widget
        set_gtk_property!(scrolled, :margin_start, 10)
        set_gtk_property!(scrolled, :margin_end, 10)
        set_gtk_property!(scrolled, :margin_top, 10)
        set_gtk_property!(scrolled, :margin_bottom, 10)
        window[] = scrolled
        show(window)
        return new(window, widget, buffer)
    end
end

# the app
const APP = AppState()

""" Send keystroke or char to a TextView widget using synthetic key events """
function sendsynthetickey(widget, keychar::Char)
    Gtk4.grab_focus(widget)
    if isa(widget, GtkTextView)
        buf = APP.target_buffer
        cursor_iter = Gtk4.G_.get_iter_at_mark(buf, Gtk4.G_.get_insert(buf))
        Gtk4.insert!(buf, Ref(cursor_iter), string(keychar))
        return true
    else
        println("Widget is not a text view, cannot insert character directly.")
        return false
    end
end

""" Send a string of text to the target widget """
function typetowidget(text::AbstractString; delay = 0.4)
    println("Sending text: \"$text\"")
    for char in text
        sendsynthetickey(APP.target_widget, char)
        sleep(delay * rand() * rand())
    end
end


# Run a demo
println("Julia Keystroke Simulation with Gtk4.jl")
println("Press Ctrl+C to exit or close the target window.")
println("=======================================")
sleep(2)  # Give time to see the window
try
    typetowidget("Hello from Gtk4.jl!\n")
    sleep(1)
    typetowidget("This is a demonstration of simulated human typing input.\n")
    typetowidget("Special characters: !@#\$%^&*()\n")
    typetowidget("You can close this window to stop the simulation.\n\n")
    while get_gtk_property(APP.target_window, :visible, Bool)
        typetowidget(string(rand(['a':'z'; collect("             "); '\n'])))
    end
catch e
    print("Caught exception: $e...")
finally
    print("Cleaning up...")
    !isnothing(APP.target_window) && close(APP.target_window)
    println("Done.")
end
