def r
  rand(10000)
end

STDOUT << "".tap do |html|
  html << "<table>"
  [
    ['X', 'Y', 'Z'],
    [r ,r ,r],
    [r ,r ,r],
    [r ,r ,r],
    [r ,r ,r]

  ].each_with_index do |row, index|
    html << "<tr>"
    html << "<td>#{index > 0 ? index : nil }</td>"
    html << row.map { |e| "<td>#{e}</td>"}.join
    html << "</tr>"
  end

  html << "</table>"
end
