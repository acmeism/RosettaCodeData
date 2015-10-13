text = <<EOS
####        #
#   #       #
#   #       #
####  #  #  ###  #   #
# #   #  #  #  #  # #
#  #  #  #  #  #   #
#   #  ###  ###   #
                 #
                #
EOS

def banner3D_1(text, shift=-1)
  txt = text.each_line.map{|line| line.gsub('#','__/').gsub(' ','   ')}
  offset = Array.new(txt.size){|i| " " * shift.abs * i}
  offset.reverse! if shift < 0
  puts offset.zip(txt).map(&:join)
end
banner3D_1(text)

puts
# Other display:
def banner3D_2(text, shift=-2)
  txt = text.each_line.map{|line| line.chomp + ' '}
  offset = txt.each_index.map{|i| " " * shift.abs * i}
  offset.reverse! if shift < 0
  txt.each_with_index do |line,i|
    line2 = offset[i] + line.gsub(' ','   ').gsub('#','///').gsub('/ ','/\\')
    puts line2, line2.tr('/\\\\','\\\\/')
  end
end
banner3D_2(text)

puts
# Another display:
def banner3D_3(text)
  txt = text.each_line.map(&:rstrip)
  offset = [*0...txt.size].reverse
  area = Hash.new(' ')
  box = [%w(/ / / \\), %w(\\ \\ \\ /)]
  txt.each_with_index do |line,i|
    line.each_char.with_index do |c,j|
      next if c==' '
      x = offset[i] + 2*j
      box[0].each_with_index{|c,k| area[[x+k,i  ]] = c}
      box[1].each_with_index{|c,k| area[[x+k,i+1]] = c}
    end
  end
  (xmin, xmax), (ymin, ymax) = area.keys.transpose.map(&:minmax)
  puts (ymin..ymax).map{|y| (xmin..xmax).map{|x| area[[x,y]]}.join}
end

banner3D_3 <<EOS
####         #
#   #        #
#   #        #
#   #        #
####   #  #  ####  #     #
# #    #  #  #   #  #   #
#  #   #  #  #   #   # #
#   #  #  #  #   #    #
#    #  ###  ####    #
                    #
                   #
EOS
