class Price
  ConversionTable = <<-END_OF_TABLE
    >=  0.00  <  0.06  :=  0.10
    >=  0.06  <  0.11  :=  0.18
    >=  0.11  <  0.16  :=  0.26
    >=  0.16  <  0.21  :=  0.32
    >=  0.21  <  0.26  :=  0.38
    >=  0.26  <  0.31  :=  0.44
    >=  0.31  <  0.36  :=  0.50
    >=  0.36  <  0.41  :=  0.54
    >=  0.41  <  0.46  :=  0.58
    >=  0.46  <  0.51  :=  0.62
    >=  0.51  <  0.56  :=  0.66
    >=  0.56  <  0.61  :=  0.70
    >=  0.61  <  0.66  :=  0.74
    >=  0.66  <  0.71  :=  0.78
    >=  0.71  <  0.76  :=  0.82
    >=  0.76  <  0.81  :=  0.86
    >=  0.81  <  0.86  :=  0.90
    >=  0.86  <  0.91  :=  0.94
    >=  0.91  <  0.96  :=  0.98
    >=  0.96  <  1.01  :=  1.00
  END_OF_TABLE

  RE = %r{ ([<>=]+) \s* (\d\.\d\d) \s* ([<>=]+) \s* (\d\.\d\d) \D+ (\d\.\d\d) }x

  # extract the comparison operators and numbers from the table
  CONVERSION_TABLE = ConversionTable.lines.inject([]) do |table, line|
    m = line.match(RE)
    if not m.nil? and m.length == 6
      table << [m[1], m[2].to_f, m[3], m[4].to_f, m[5].to_f]
    end
    table
  end

  MIN_COMP, MIN = CONVERSION_TABLE[0][0..1]
  MAX_COMP, MAX = CONVERSION_TABLE[-1][2..3]

  def initialize(value)
    if (not value.send(MIN_COMP, MIN)) or (not value.send(MAX_COMP, MAX))
      raise ArgumentError, "value=#{value}, must have: #{MIN} #{MIN_COMP} value #{MAX_COMP} #{MAX}"
    end
    @standard_value = CONVERSION_TABLE.find do |comp1, lower, comp2, upper, standard|
      value.send(comp1, lower) and value.send(comp2, upper)
    end.last
  end
  attr_reader :standard_value
end
