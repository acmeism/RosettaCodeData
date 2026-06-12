def split_text_with_dict(text, dict, splited=[])
  solutions = []
  dict.each do |word|
    if text.start_with? word
      new_text = text.delete_prefix word
      new_splited = splited.dup<< word
      if new_text.empty?
        solutions << new_splited
      else
        sols = split_text_with_dict(new_text, dict, new_splited)
        sols.each { |s| solutions << s }
      end
    end
  end
  return solutions
end
