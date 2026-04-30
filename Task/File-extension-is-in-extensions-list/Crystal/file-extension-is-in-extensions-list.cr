extensions = ["zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2"]

filenames = ["MyData.a##", "MyData.tar.Gz", "MyData.gzip", "MyData.7z.backup",
             "MyData...", "MyData", "MyData_v1.0.tar.bz2", "MyData_v1.0.bz2"]

width = filenames.max_of &.size

filenames.each do |fn|
  printf "%-#{width}s  %s\n", fn,
         extensions.map(&.downcase.ensure_prefix ".").any? {|ext| fn.downcase.ends_with? ext }
end
