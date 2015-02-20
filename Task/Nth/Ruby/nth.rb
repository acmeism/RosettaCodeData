class Integer
  def ordinalize
    num = self.abs
    ordinal = if (11..13).include?(num % 100)
      "th"
    else
      case num % 10
        when 1; "st"
        when 2; "nd"
        when 3; "rd"
        else    "th"
      end
    end
    "#{self}#{ordinal}"
  end
end

[(0..25),(250..265),(1000..1025)].each{|r| puts r.map(&:ordinalize).join(", "); puts}
