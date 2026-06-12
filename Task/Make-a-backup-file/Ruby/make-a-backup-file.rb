def backup_and_open(filename)
  filename = File.realpath(filename)
  bkup = filename + ".backup"
  backup_files = Dir.glob(bkup + "*").sort_by do |f|
    f.match(/\d+$/)
    $&.nil? ? 0 : $&.to_i
  end
  backup_files.reverse.each do |fname|
    if m = fname.match(/\.backup\.(\d+)$/)
      File.rename(fname, "%s.%d" % [bkup, m[1].to_i + 1])
    elsif fname == bkup
      File.rename(bkup, bkup + ".1")
    end
  end
  File.rename(filename, bkup)
  File.open(filename, "w") {|handle| yield handle}
end

1.upto(12) {|i| backup_and_open(ARGV[0]) {|fh| fh.puts "backup #{i}"}}
