T_HEIGHT = sqrt(3) / 2
TOP_Y = 1 / sqrt(3)
BOT_Y = sqrt(3) / 6
TRIANGLE_SIZE = 800

def settings
  size(TRIANGLE_SIZE, (T_HEIGHT * TRIANGLE_SIZE))
  smooth
end

def setup
  sketch_title 'Sierpinski Triangle'
  fill(255)
  background(0)
  no_stroke
  draw_sierpinski(width / 2, height / 1.5, TRIANGLE_SIZE)
end

def draw_sierpinski(cx, cy, sz)
  if sz < 5 # Limit no of recursions on size
    draw_triangle(cx, cy, sz) # Only draw terminals
  else
    cx0 = cx
    cy0 = cy - BOT_Y * sz
    cx1 = cx - sz / 4
    cy1 = cy + (BOT_Y / 2) * sz
    cx2 = cx + sz / 4
    cy2 = cy + (BOT_Y / 2) * sz
    draw_sierpinski(cx0, cy0, sz / 2)
    draw_sierpinski(cx1, cy1, sz / 2)
    draw_sierpinski(cx2, cy2, sz / 2)
  end
end

def draw_triangle(cx, cy, sz)
  cx0 = cx
  cy0 = cy - TOP_Y * sz
  cx1 = cx - sz / 2
  cy1 = cy + BOT_Y * sz
  cx2 = cx + sz / 2
  cy2 = cy + BOT_Y * sz
  triangle(cx0, cy0, cx1, cy1, cx2, cy2)
end
