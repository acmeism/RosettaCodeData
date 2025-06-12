NOTES = "NOTES.TXT"

if ARGV.empty?
  print File.read(NOTES)  rescue nil
else
  File.open NOTES, "a" do |f|
    f.puts "#{Time.local}\n\t#{ARGV.join(" ")}"
  end
end
