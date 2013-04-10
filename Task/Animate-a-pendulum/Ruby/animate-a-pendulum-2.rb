Shoes.app(:width => 320, :height => 200) do
  @centerX = 160
  @centerY = 25
  @length = 150
  @diameter = 15

  @Theta = 45.0
  @dTheta = 0.0

  stroke gray
  strokewidth 3
  line 0,25,320,25
  oval 155,20,10

  stroke black
  @rod = line(@centerX, @centerY, @centerX, @centerY + @length)
  @bob = oval(@centerX - @diameter, @centerY + @length - @diameter, 2*@diameter)

  animate(24) do |i|
    recompute_angle
    show_pendulum
  end

  def show_pendulum
    angle = (90 + @Theta) * Math::PI / 180
    x = @centerX + (Math.cos(angle) * @length).to_i
    y = @centerY + (Math.sin(angle) * @length).to_i

    @rod.remove
    strokewidth 3
    @rod = line(@centerX, @centerY, x, y)
    @bob.move(x-@diameter, y-@diameter)
  end

  def recompute_angle
    scaling = 3000.0 / (@length **2)
    # first estimate
    firstDDTheta = -Math.sin(@Theta * Math::PI / 180) * scaling
    midDTheta = @dTheta + firstDDTheta
    midTheta = @Theta + (@dTheta + midDTheta)/2
    # second estimate
    midDDTheta = -Math.sin(midTheta * Math::PI / 180) * scaling
    midDTheta = @dTheta + (firstDDTheta + midDDTheta)/2
    midTheta = @Theta + (@dTheta + midDTheta)/2
    # again, first
    midDDTheta = -Math.sin(midTheta * Math::PI / 180) * scaling
    lastDTheta = midDTheta + midDDTheta
    lastTheta = midTheta + (midDTheta + lastDTheta)/2
    # again, second
    lastDDTheta = -Math.sin(lastTheta * Math::PI/180) * scaling
    lastDTheta = midDTheta + (midDDTheta + lastDDTheta)/2
    lastTheta = midTheta + (midDTheta + lastDTheta)/2
    # Now put the values back in our globals
    @dTheta  = lastDTheta
    @Theta = lastTheta
  end
end
