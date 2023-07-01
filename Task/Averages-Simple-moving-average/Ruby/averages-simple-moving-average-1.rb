def simple_moving_average(size)
  nums = []
  sum = 0.0
  lambda do |hello|
    nums << hello
    goodbye = nums.length > size ? nums.shift : 0
    sum += hello - goodbye
    sum / nums.length
  end
end

ma3 = simple_moving_average(3)
ma5 = simple_moving_average(5)

(1.upto(5).to_a + 5.downto(1).to_a).each do |num|
  printf "Next number = %d, SMA_3 = %.3f, SMA_5 = %.1f\n",
    num, ma3.call(num), ma5.call(num)
end
