class ElemCellAutomat
  include Enumerable

  def initialize (start_str, rule, disp=false)
    @cur = start_str
    @patterns = Hash[8.times.map{|i|["%03b"%i, "01"[rule[i]]]}]
    puts "Rule (#{rule}) : #@patterns" if disp
  end

  def each
    return to_enum unless block_given?
    loop do
      yield @cur
      str = @cur[-1] + @cur + @cur[0]
      @cur = @cur.size.times.map {|i| @patterns[str[i,3]]}.join
    end
  end

end

eca = ElemCellAutomat.new('1'.center(39, "0"), 18, true)
eca.take(30).each{|line| puts line.tr("01", ".#")}
