Shoes.app(:width=>205, :height => 228, :title => "A Clock") do
  def draw_ray(width, start, stop, ratio)
    angle = Math::PI * 2 * ratio - Math::PI/2
    strokewidth width
    cos = Math::cos(angle)
    sin = Math::sin(angle)
    line 101+cos*start, 101+sin*start, 101+cos*stop, 101+sin*stop
  end

  def update
    t = Time.now
    @time.text = t.strftime("%H:%M:%S")
    h, m, s = (t.hour % 12).to_f, t.min.to_f, t.sec.to_f
    s += t.to_f - t.to_i  # add the fractional seconds

    @hands.clear do
      draw_ray(3, 0, 70, (h + m/60)/12)
      draw_ray(2, 0, 90, (m + s/60)/60)
      draw_ray(1, 0, 95, s/60)
    end
  end

  # a place for the text display
  @time = para(:align=>"center", :family => "monospace")

  # draw the clock face
  stack(:width=>203, :height=>203) do
    strokewidth 1
    fill gradient(deepskyblue, aqua)
    oval 1, 1, 200
    fill black
    oval 98, 98, 6
    # draw the minute indicators
    0.upto(59) {|m| draw_ray(1, (m % 5 == 0 ? 96 : 98), 100, m.to_f/60)}
  end.move(0,23)

  # the drawing area for the hands
  @hands = stack(:width=>203, :height=>203) {}.move(0,23)

  animate(5) {update}
end
