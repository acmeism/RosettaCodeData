def conjugate(infinitive)
    return ["Can not conjugate #{infinitive}"] if infinitive.size < 4
  conjugations = case infinitive[-3..-1]
    when "are" then ["o", "as", "at", "amus", "atis", "ant"]
    when "ēre" then ["eo", "es", "et", "emus", "etis", "ent"]
    when "ere" then ["o", "is", "it", "imus", "itis", "unt"]
    when "ire" then ["io", "is", "it", "imus", "itis", "iunt"]
    else return ["Can not conjugate #{infinitive}"]
  end
  conjugations.map{|c| infinitive[0..-4] + c}
end

["amare", "vidēre", "ducere", "audire","qwerty", "are"].each do |inf|
    puts "\n" + inf + ":"
    puts conjugate inf
end
