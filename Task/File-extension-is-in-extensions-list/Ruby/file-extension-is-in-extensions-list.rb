def is_ext(filename, extensions)
  if filename.respond_to?(:each)
    filename.each do |fn|
      is_ext(fn, extensions)
    end
  else
    fndc = filename.downcase
    extensions.each do |ext|
      bool = fndc.end_with?(?. + ext.downcase)
      puts "%20s : %s" % [filename, bool] if bool
    end
  end
end
