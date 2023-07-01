ar.sort_by{|str| str.downcase.gsub(/\Athe |\Aa |\Aan /, "").lstrip.gsub(/\s+/, " ")}
