words = File.readlines("unixdict.txt")
            .group_by{|x| [x.strip!, x.reverse].min}
            .values
            .select{|v| v.size==2}
puts "There are #{words.size} semordnilaps, of which the following are 5:"
words.take(5).each {|a,b| puts "#{a}   #{b}"}
