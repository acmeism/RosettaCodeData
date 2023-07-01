# create tmp fasta file in /tmp/
tmpfile = "/tmp/tmp"+Random.rand.to_s+".fasta"
File.write(tmpfile, ">Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED")

# read tmp fasta file and store to hash
ref = tmpfile
id = seq = ""
fasta = {} of String => String
File.each_line(ref) do |line|
  if line.starts_with?(">")
    fasta[id] = seq.sub(/\s/, "") if id != ""
    id = line.split(/\s/)[0].lstrip(">")
    seq = ""
  else
    seq += line
  end
end
fasta[id] = seq.sub(/\s/, "")

# show fasta component
fasta.each { |k,v| puts "#{k}: #{v}"}
