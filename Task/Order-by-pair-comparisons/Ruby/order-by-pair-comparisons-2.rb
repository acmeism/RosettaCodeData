items = ["violet", "red", "green", "indigo", "blue", "yellow", "orange"]
count = 0
p items.sort {|a, b|
  count += 1
  print "(#{count}) Is #{a} <, =, or > #{b}. Answer -1, 0, or 1: "
  gets.to_i
}
