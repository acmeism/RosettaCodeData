def fasta_format(strings)
  out, text = [], ""
  strings.split("\n").each do |line|
    if line[0] == '>'
      out << text unless text.empty?
      text = line[1..-1] + ": "
    else
      text << line
    end
  end
  out << text unless text.empty?
end

data = <<'EOS'
>Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED
EOS

puts fasta_format(data)
