lines = 5

(0..lines).each do |exp|
  seg_size = 3**(lines-exp-1)
  chars = (3**exp).times.map{ |n| n.digits(3).any?(1) ? " " : "█"}
  puts chars.map{ |c| c * seg_size }.join
end
