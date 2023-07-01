groups = [{A: [1, 2, 3]},
          {A: [1, :B, 2], B: [3, 4]},
          {A: [1, :D, :D], D: [6, 7, 8]},
          {A: [1, :B, :C], B: [3, 4], C: [5, :B]} ]

groups.each do |group|
  p group
  wheels = group.transform_values(&:cycle)
  res = 20.times.map do
    el = wheels[:A].next
    el = wheels[el].next until el.is_a?(Integer)
    el
  end
  puts res.join(" "),""
end
