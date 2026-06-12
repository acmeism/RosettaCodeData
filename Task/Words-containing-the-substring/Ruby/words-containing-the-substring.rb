File.foreach("unixdict.txt"){|w| puts w if w.size > 11 && w.match?("the") }
