def draw_cistercian_numerals (rows, *, size=20, decimals_size=0)
  # characters are 2 units height, later scaled
  hwidth = 0.888      # half width
  line_width = 0.2
  hlw = line_width/2
  margin = line_width
  scale = size/2
  interline = 0.2
  # top right quadrant is hwidth x -1. here are some distances from 0
  top = -1
  toph = top + hlw   # center of top horizontal line
  midv = -0.555
  bot = -0.111
  both = bot - hlw   # center of bottom horizontal line

  # horizontal shift left for c3 & c4
  shift = hlw/Math.sin(Math.atan((top-bot).abs/(hwidth-hlw)))

  left = 0               # center of stem
  leftx = hlw            # right border of stem
  midh = hwidth / 2
  right = hwidth
  rightv = hwidth - hlw  # center of right vertical line

  width = rows.max_of(&.size) * (2*hwidth + 2*margin) * scale
  height = (rows.size * (2 + 2*margin) + (rows.size-1)*interline) * scale +
           rows.size * decimals_size

  svg = String.build do |s|
    s << <<-SVG << "\n"
<svg width="#{width}" height="#{height}" background="white" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <clipPath id="qclip"><rect x="0" y="-1" width="#{hwidth}" height="#{1+bot}" /></clipPath>
    <path id="stem" d="M 0,1 v -2"/>
SVG
    # the digits' drawing instructions
    digits = [[0,toph,    'H', right],           # 1
              [0,midv,    'H', right],           # 2
              [leftx-shift,top, 'L', right-shift,bot, 's'], # 3
              [leftx-shift,bot, 'L', right-shift,top, 's'], # 4
              [midh,midv, 'V', bot],             # 5
              [midh,top,  'V', bot],             # 6
              [0,toph,    'L', rightv,toph, rightv,bot], # 7
              [0,both,    'L', rightv,both, rightv,top], # 8
              [0,both,    'L', rightv,both, rightv,toph, 0,toph]] #9
    digits.map_with_index do |d, i|
      s << %Q(    <path id="c#{i+1}" d="M #{d[0..1].join(',')} #{d[2]})
      if d[2] == 'L'
        d[3..].each_slice(2) do |slice|
          s << " " << slice.join(',')  if slice.size == 2
        end
      else
        s << " " << d[3]
      end
      s << "\""
      s << %Q( stroke-linecap="square") if d[-1] == 's'
      s << %Q( clip-path="url(#qclip)" />\n)
    end
    s << "</defs>\n"
    s << %Q(<rect x="0" y="0" width="#{width}" height="#{height}" stroke="none" fill="white" />\n)
    y = (2 + margin) * scale
    rows.each do |row|
      x = 0
      row.each do |number|
        s << %Q(  <g transform="translate(#{x},#{y}) scale(#{scale})">\n)
        s << %Q(    <g stroke="black" stroke-width="#{line_width}" )
        s <<        %Q(fill="none" transform="translate(#{hwidth+margin},-1)">\n)
        s << %Q(      <use href="#stem" />\n)
        n = number
        [nil, "scale(-1,1)", "rotate(180) scale(-1,1)", "rotate(180)"].each do |transform|
          if n % 10 > 0
            s << %Q(      <use href="#c#{n % 10}" )
            s << %Q(transform="#{transform}") if transform
            s << "/>\n"
          end
          n //= 10
        end
        s << "    </g>\n  </g>\n"
        if decimals_size > 0
          s << %Q(  <text x="#{x+(margin+hwidth)*scale}" y="#{y+decimals_size}" )
          s << %Q(text-anchor="middle" style="font-size: #{decimals_size}px">)
          s << %Q(#{number}</text>\n)
        end
        x += (2*margin + 2*hwidth) * scale
      end
      y += (interline + 2*margin + 2) * scale + decimals_size
    end
    s << "</svg>\n"
  end
  puts svg
end

draw_cistercian_numerals [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                          [20, 300, 4000, 5555, 6789, 1234, 6502, 2025, 8634, 5954],
                          (0..9).map { rand(10000) }],
                          size: 70, decimals_size: 18
