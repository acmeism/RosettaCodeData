def truncate_file (filename, pos)
  File.open(filename, "r+") do |f|
    f.truncate pos
  end
end

truncate_file "test.txt", 10
