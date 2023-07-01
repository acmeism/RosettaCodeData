# Open a file for writing, and truncate it to 1234 bytes.
File.open("file", "ab") do |f|
  f.truncate(1234)
  f << "Killroy was here" # write to file
end  # file is closed now.

# Just truncate a file to 567 bytes.
File.truncate("file", 567)
