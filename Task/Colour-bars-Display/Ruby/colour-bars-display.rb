# Array of web colors black, red, green, blue, magenta, cyan, yellow, white
PALETTE = %w[#000000 #ff0000 #00ff00 #0000ff #ff00ff #00ffff #ffffff].freeze

def settings
  full_screen
end

def setup
  PALETTE.each_with_index do |col, idx|
    fill color(col)
    rect(idx * width / 8, 0, width / 8, height)
  end
end
