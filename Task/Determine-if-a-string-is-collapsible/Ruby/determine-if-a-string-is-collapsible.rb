strings = ["",
        '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ',
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                   ---  Harry S Truman  ",
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
        "headmistressship",
        "aardvark",
        "😍😀🙌💃😍😍😍🙌",]

strings.each do |str|
  puts "«««#{str}»»» (size #{str.size})"
  ssq = str.squeeze
  puts "«««#{ssq}»»» (size #{ssq.size})"
  puts
end
