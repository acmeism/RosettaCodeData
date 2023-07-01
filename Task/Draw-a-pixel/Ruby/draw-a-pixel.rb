require 'gtk3'

Width, Height = 320, 240
PosX, PosY = 100, 100

window = Gtk::Window.new
window.set_default_size(Width, Height)
window.title = 'Draw a pixel'

window.signal_connect(:draw) do |widget, context|
  context.set_antialias(Cairo::Antialias::NONE)
  # paint out bg with white
  # context.set_source_rgb(1.0, 1.0, 1.0)
  # context.paint(1.0)
  # draw a rectangle
  context.set_source_rgb(1.0, 0.0, 0.0)
  context.fill do
    context.rectangle(PosX, PosY, 1, 1)
  end
end

window.signal_connect(:destroy) { Gtk.main_quit }

window.show
Gtk.main
