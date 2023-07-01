words = %w(A BaRK BOoK tREaT COmMOn SqUAD CoNfuSE) << ""

words.each do |word|
  blocks = "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM"
  res = word.each_char.all?{|c| blocks.sub!(/\w?#{c}\w?/i, "")}  #regexps can be interpolated like strings
  puts "#{word.inspect}: #{res}"
end
