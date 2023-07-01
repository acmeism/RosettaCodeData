strings = ["",
        '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ',
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                   ---  Harry S Truman  ",
        "😍😀🙌💃😍😍😍🙌",]
squeeze_these = ["", "-", "7", ".", " -r", "😍"]

strings.zip(squeeze_these).each do |str, st|
  puts "original:     «««#{str}»»» (size #{str.size})"
  st.chars.each do |c|
    ssq = str.squeeze(c)
    puts "#{c.inspect}-squeezed: «««#{ssq}»»» (size #{ssq.size})"
  end
  puts
end
