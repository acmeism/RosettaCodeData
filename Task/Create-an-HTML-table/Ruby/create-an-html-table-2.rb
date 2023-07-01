def r; rand(10000); end
table = [["", "X", "Y", "Z"],
         [ 1,   r,   r,   r],
         [ 2,   r,   r,   r],
         [ 3,   r,   r,   r]]

require 'rexml/document'

xtable = REXML::Element.new("table")
table.each do |row|
  xrow = REXML::Element.new("tr", xtable)
  row.each do |cell|
    xcell = REXML::Element.new("td", xrow)
    REXML::Text.new(cell.to_s, false, xcell)
  end
end

formatter = REXML::Formatters::Pretty.new
formatter.compact = true
formatter.write(xtable, $stdout)
