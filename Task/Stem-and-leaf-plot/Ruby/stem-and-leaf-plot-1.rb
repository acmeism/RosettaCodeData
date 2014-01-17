class StemLeafPlot
  def initialize(data, options = {})
    opts = {:leaf_digits => 1}.merge(options)
    @leaf_digits = opts[:leaf_digits]
    @multiplier = 10 ** @leaf_digits
    @plot = generate_structure(data)
  end

  private

  def generate_structure(data)
    plot = Hash.new {|h,k| h[k] = []}
    data.sort.each do |value|
      stem, leaf = parse(value)
      plot[stem] << leaf
    end
    plot
  end

  def parse(value)
    stem, leaf = value.abs.divmod(@multiplier)
    [Stem.get(stem, value), leaf.round]
  end

  public

  def print
    stem_width = Math.log10(@plot.keys.max_by {|s| s.value}.value).ceil + 1
    Stem.get_range(@plot.keys).each do |stem|
      leaves = @plot[stem].inject("") {|str,leaf| str << "%*d " % [@leaf_digits, leaf]}
      puts "%*s | %s" % [stem_width, stem, leaves]
    end

    puts "key: 5|4=#{5 * @multiplier + 4}"
    puts "leaf unit: 1"
    puts "stem unit: #@multiplier"
  end
end

class Stem
  @@cache = {}

  def self.get(stem_value, datum)
    sign = datum < 0 ? :- : :+
    cache(stem_value, sign)
  end

  private

  def self.cache(value, sign)
    if @@cache[[value, sign]].nil?
      @@cache[[value, sign]] = self.new(value, sign)
    end
    @@cache[[value, sign]]
  end

  def initialize(value, sign)
    @value = value
    @sign = sign
  end

  public

  attr_accessor :value, :sign

  def negative?
    @sign == :-
  end

  def <=>(other)
    if self.negative?
      if other.negative?
        other.value <=> self.value
      else
        -1
      end
    else
      if other.negative?
        1
      else
        self.value <=> other.value
      end
    end
  end

  def to_s
    "%s%d" % [(self.negative? ? '-' : ' '), @value]
  end

  def self.get_range(array_of_stems)
    min, max = array_of_stems.minmax
    if min.negative?
      if max.negative?
        min.value.downto(max.value).collect {|n| cache(n, :-)}
      else
        min.value.downto(0).collect {|n| cache(n, :-)} + 0.upto(max.value).collect {|n| cache(n, :+)}
      end
    else
      min.value.upto(max.value).collect {|n| cache(n, :+)}
    end
  end

end

data = DATA.read.split.map {|s| Float(s)}
StemLeafPlot.new(data).print

__END__
12 127 28 42 39 113 42 18 44 118 44 37 113 124 37 48 127 36 29 31 125 139 131
115 105 132 104 123 35 113 122 42 117 119 58 109 23 105 63 27 44 105 99 41 128
121 116 125 32 61 37 127 29 113 121 58 114 126 53 114 96 25 109 7 31 141 46 13
27 43 117 116 27 7 68 40 31 115 124 42 128 52 71 118 117 38 27 106 33 117 116
111 40 119 47 105 57 122 109 124 115 43 120 43 27 27 18 28 48 125 107 114 34
133 45 120 30 127 31 116 146
