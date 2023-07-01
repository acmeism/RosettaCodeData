lists = ["unixdict.txt", "wordlist.10000", "woordenlijst.txt"]

lists.each do |list|
  words = open(list).readlines( chomp: true).reject{|w| w.size < 3 }
  grouped_by_size = words.group_by(&:size)
  tea_words = words.filter_map do |word|
    chars = word.chars
    next unless chars.none?{|c| c < chars.first }
    next if chars.uniq.size == 1
    rotations = word.size.times.map {|i| chars.rotate(i).join }
    rotations if rotations.all?{|rot| grouped_by_size[rot.size].include? rot }
  end
  puts "", list + ":"
  tea_words.uniq(&:to_set).each{|ar| puts ar.join(", ") }
end
