p words.sort {|a, b| d = b.size <=> a.size
                     d != 0 ? d : a.upcase <=> b.upcase}
