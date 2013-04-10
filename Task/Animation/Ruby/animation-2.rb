Shoes.app do
  @direction = 1
  @label = para "Hello World! ", :family => 'monospace'

  click {|button, left, top| @direction *= -1 if button == 1}

  animate(8) do |f|
    t = @label.text
    @label.text = @direction > 0 ? t[-1] + t[0..-2] : t[1..-1] + t[0]
  end
end
