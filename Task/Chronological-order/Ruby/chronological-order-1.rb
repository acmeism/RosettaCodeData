def chronological_order(data)
  data.lines(chomp: true).sort_by! do |line|
    match = line.match(/(\d+)\s+(B?CE)/)
    if match
      match[2] == "BCE" ? -match[1].to_i : match[1].to_i
    else
      Float::INFINITY
    end
  end.join("\n")
end

puts chronological_order(ARGF.read) if __FILE__ == $PROGRAM_NAME
