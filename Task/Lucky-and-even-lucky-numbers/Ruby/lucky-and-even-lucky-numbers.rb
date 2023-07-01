def generator(even=false, nmax=1000000)
  start = even ? 2 : 1
  Enumerator.new do |y|
    n = 1
    ary = [0] + (start..nmax).step(2).to_a      # adds [0] to revise the 0 beginnings.
    y << ary[n]
    while (m = ary[n+=1]) < ary.size
      y << m
      (m...ary.size).step(m){|i| ary[i]=nil}
      ary.compact!                              # remove nil
    end
    # drain
    ary[n..-1].each{|i| y << i}
    raise StopIteration
  end
end

def lucky(argv)
  j, k = argv[0].to_i, argv[1].to_i
  mode = /even/i=~argv[2] ? :'even lucky' : :lucky
  seq = generator(mode == :'even lucky')
  ord = ->(n){"#{n}#{(n%100).between?(11,19) ? 'th' : %w[th st nd rd th th th th th th][n%10]}"}
  if k.zero?
    puts "#{ord[j]} #{mode} number: #{seq.take(j).last}"
  elsif 0 < k
    puts "#{ord[j]} through #{ord[k]} (inclusive) #{mode} numbers",
         "  #{seq.take(k)[j-1..-1]}"
  else
    k = -k
    ary = []
    loop do
      case num=seq.next
      when 1...j
      when j..k  then ary << num
      else break
      end
    end
    puts "all #{mode} numbers in the range #{j}..#{k}",
         "  #{ary}"
  end
end

if __FILE__ == $0
  lucky(ARGV)
end
