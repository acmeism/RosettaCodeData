Shoes.app(:title => "Berlin-Uhr Clock", :width => 209, :height => 300) do
  background lightgrey

  Red = rgb(255, 20, 20)
  Yellow = rgb(173, 255, 47)
  Green = rgb(154, 205, 50)
  Gray = rgb(128, 128, 128)

  @time = para(:align => "center")
  stack do
    fill Gray
    stroke black
    strokewidth 2
    @seconds = oval 75, 3, 50
    @hrs_a  =  4.times.collect {|i| rect   51*i,  56, 48, 30, 4}
    @hrs_b  =  4.times.collect {|i| rect   51*i,  89, 48, 30, 4}
    @mins_a = 11.times.collect {|i| rect 2+18*i, 122, 15, 30, 4}
    @mins_b =  4.times.collect {|i| rect   51*i, 155, 48, 30, 4}
    # some decoration
    fill white
    stroke darkslategray
    rect -10, -30, 75, 70, 10
    rect 140, -30, 75, 70, 10
    rect -13, 192, 105, 100, 10
    rect 110, 192, 105, 100, 10
  end.move(3,20)

  animate(1) do
    now = Time.now
    @time.text = now.strftime("%H:%M:%S")
    @seconds.style(:fill => now.sec.even? ? Green : Gray)
    a, b = now.hour.divmod(5)
    4.times {|i| @hrs_a[i].style(:fill => i < a ? Red : Gray)}
    4.times {|i| @hrs_b[i].style(:fill => i < b ? Red : Gray)}
    a, b = now.min.divmod(5)
    11.times {|i| @mins_a[i].style(:fill => i < a ? (i%3==2 ? Red : Yellow) : Gray)}
    4.times  {|i| @mins_b[i].style(:fill => i < b ? Yellow : Gray)}
  end

  keypress do |key|
    case key
    when :control_q, "\x11" then exit
    end
  end
end
