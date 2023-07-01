descriptions = {
  :fly    => "I don't know why S",
  :spider => "That wriggled and jiggled and tickled inside her.",
  :bird   => "Quite absurd T",
  :cat    => "Fancy that, S",
  :dog    => "What a hog, S",
  :goat   => "She opened her throat T",
  :cow    => "I don't know how S",
  :horse  => "She's dead, of course.",
}
animals = descriptions.keys

animals.each_with_index do |animal, idx|
  puts "There was an old lady who swallowed a #{animal}."

  d = descriptions[animal]
  case d[-1]
  when "S" then d[-1] = "she swallowed a #{animal}."
  when "T" then d[-1] = "to swallow a #{animal}."
  end
  puts d
  break if animal == :horse

  idx.downto(1) do |i|
    puts "She swallowed the #{animals[i]} to catch the #{animals[i-1]}."
    case animals[i-1]
    when :spider, :fly then puts descriptions[animals[i-1]]
    end
  end

  print "Perhaps she'll die.\n\n"
end
