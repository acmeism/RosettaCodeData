require "crimage"

PHI = (1 + Math.sqrt(5)) / 2

scale = 300
seeds = 1000

img = CrImage.rgba(scale, scale, CrImage::Color::BLACK)
gold = CrImage::Color.rgb(255, 215, 0)

(1..seeds).each do |i|
  r = 2 * (i**PHI) / seeds
  t = 2 * Math::PI * PHI * i
  x = r * Math.sin(t) + scale/2
  y = r * Math.cos(t) + scale/2

  cx, cy, cr = [x, y, Math.sqrt(i)/13].map(&.round.to_i)

  img.draw_circle(cx, cy, cr, gold, anti_alias: true)
end

CrImage.write("sunflower_crystal.png", img)
