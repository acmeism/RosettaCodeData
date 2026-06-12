["http://example.com/download.tar.gz",
 "CharacterModel.3DS",
 ".desktop",
 "document",
 "document.txt_backup",
 "/etc/pam.d/login"].each do |fn|
  ext = fn[/\.[A-Za-z0-9]*$/]?.to_s
  puts "#{fn} -> #{ext}"
end
