open("outfile.dat", "w") do |out_f|
  open("infile.dat") do |in_f|
     while record = in_f.read(80)
       out_f << record.reverse
     end
  end
end  # both files automatically closed
