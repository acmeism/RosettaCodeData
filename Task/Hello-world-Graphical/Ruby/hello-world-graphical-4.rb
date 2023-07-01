require 'gosu'

class Window < Gosu::Window

  def initialize
    super(150, 50, false)
    @font = Gosu::Font.new(self, "Arial", 32)
  end

  def draw
    @font.draw("Hello world", 0, 10, 1, 1, 1)
  end

end

Window.new.show
