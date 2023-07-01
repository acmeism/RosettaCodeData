# IO.foreach and File.foreach can also read a subprocess.
IO.foreach "| grep afs3 /etc/services" do |line|
  puts line
end
