require "crimage"

rules = { A: "",
          M: "OA++PA----NA[-OA----MA]++",
          N: "+OA--PA[---MA--NA]+",
          O: "-MA++NA[+++OA++PA]-",
          P: "--OA++++MA[+PA++++NA]--NA"
        }
penrose = "[N]++[N]++[N]++[N]++[N]"
4.times do
  penrose = penrose.gsub /[AMNOP]/, rules
end

x, y = 160.0, 160.0
theta = Math::PI / 5
r  = 20.0

def point (x, y); { x.round.to_i, y.round.to_i } end

lines = Set({ { Int32, Int32 }, { Int32, Int32 } }).new
stack = [] of { Float64, Float64, Float64 }

penrose.chars.each do |ch|
  case ch
  when 'A'
    x0, y0 = x, y
    x += r * Math.cos(theta)
    y += r * Math.sin(theta)
    lines << { point(x0, y0), point(x, y) }
  when '+' then theta += Math::PI / 5
  when '-' then theta -= Math::PI / 5
  when '[' then stack << { x, y, theta }
  when ']' then x, y, theta = stack.pop
  end
end

FG = CrImage::Color.rgb(255, 165, 0)
BG = CrImage::Color::BLACK

img = CrImage.rgba(350, 350, BG)
lines.each do |line|
  img.draw_line(*line, FG)
end
CrImage.write("penrose_tiling_crystal.png", img)
