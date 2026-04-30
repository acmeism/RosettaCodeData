def shortest_supersequence (seqs)
  # remove duplicated and contained sequences
  seqs = seqs.sort_by {|s| -s.size }
  ss = [] of String
  until seqs.empty?
    seq = seqs.pop
    ss << seq unless seqs.any? &.includes?(seq)
  end
  # connect them and find shortest
  shortest = nil
  ss.each_permutation do |perm|
    superseq = perm.reduce {|sseq, seq|
      if sseq && (idx = (1...seq.size).reverse_each.find {|len| sseq.ends_with? seq[0, len] })
        sseq + seq[idx..]
      end
    }
    if superseq && (shortest.nil? || shortest.size > superseq.size)
      shortest = superseq
    end
  end
  shortest
end

sequences = [
  ["TA", "AAG", "TA", "GAA", "TA"],
  ["CATTAGGG", "ATTAG", "GGG", "TA"],
  ["AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA"],
  ["ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT",
   "GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT",
   "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
   "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
   "AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT",
   "GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC",
   "CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT",
   "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
   "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC",
   "GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT",
   "TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
   "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
   "TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA"],
]

sequences.each do |ss|
  if shortest = shortest_supersequence ss
    puts "Nucleotide counts for #{shortest}:"
    shortest.chars.tally.to_a.sort.each do |letter, count|
      puts "     #{letter}: #{count}"
    end
    puts " TOTAL= #{shortest.size}"
  else
    puts "Couldn't link #{ss.size} sequences."
  end
  puts
end
