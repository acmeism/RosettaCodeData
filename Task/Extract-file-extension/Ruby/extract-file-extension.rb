names =
%w(http://example.com/download.tar.gz
   CharacterModel.3DS
   .desktop
   document
   /etc/pam.d/login)
names.each{|name| p File.extname(name)}
