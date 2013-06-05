def luhn_perfomance_2_x_faster(i)
  i = "#{i}"
  index = i.length-1
  ct = 1
  sum = 0
  while index > -1
    i = i[index].to_i
    if ct.even?
      i = i * 2
      if i > 9
        tmp = "#{i}"
        i = 0
        tmp.each_char { |char|
          i += char.to_i
        }
      end
    end
    sum += i
    index -= 1
    ct += 1
  end
  sum % 10 == 0
end
