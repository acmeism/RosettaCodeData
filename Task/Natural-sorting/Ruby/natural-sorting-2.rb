class NatSortString
  include Comparable
  attr_reader :scrubbed, :ints_and_strings, :i_s_pattern

  def initialize(str)
    @str = str
    @scrubbed = str.downcase.gsub(/\Athe |\Aa |\Aan /, "").lstrip.gsub(/\s+/, " ")
    @ints_and_strings = @scrubbed.scan(/\d+|\D+/).map{|s| s =~ /\d/ ? s.to_i : s}
    @i_s_pattern = @ints_and_strings.map{|el| el.is_a?(Integer) ? :i : :s}.join
  end

  def <=> (other)
    if i_s_pattern.start_with?(other.i_s_pattern) or other.i_s_pattern.start_with?(i_s_pattern) then
      ints_and_strings <=> other.ints_and_strings
    else
      scrubbed <=> other.scrubbed
    end
  end

  def to_s
    @str.dup
  end

end
