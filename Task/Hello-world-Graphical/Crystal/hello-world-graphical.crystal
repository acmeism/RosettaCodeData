require "crsfml"

window = SF::RenderWindow.new(SF::VideoMode.new(800, 600), "Hello world/Graphical")

# A font file(s) MUST be in the directory of the Crystal file itself.
# CrSFML does NOT load font files from the filesystem root!
font = SF::Font.from_file("DejaVuSerif-Bold.ttf")

text = SF::Text.new
text.font = font

text.string = "Goodbye, world!"
text.character_size = 24

text.color = SF::Color::Black

while window.open?
  while event = window.poll_event
    if event.is_a? SF::Event::Closed
      window.close
    end
  end

  window.clear(SF::Color::White)

  window.draw(text)

  window.display
end
