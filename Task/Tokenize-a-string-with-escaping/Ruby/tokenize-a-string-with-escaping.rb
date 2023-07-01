def tokenize(string, sep, esc)
  sep = Regexp.escape(sep)
  esc = Regexp.escape(esc)
  string.scan(/\G (?:^ | #{sep}) (?: [^#{sep}#{esc}] | #{esc} .)*/x).collect do |m|
    m.gsub(/#{esc}(.)/, '\1').gsub(/^#{sep}/, '')
  end
end

p tokenize('one^|uno||three^^^^|four^^^|^cuatro|', '|', '^')
