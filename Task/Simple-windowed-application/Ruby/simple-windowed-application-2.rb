Shoes.app do
  stack do
    @count = 0
    @label = para "no clicks yet"
    button "click me" do
      @count += 1
      @label.text = "click: #@count"
    end
  end
end
