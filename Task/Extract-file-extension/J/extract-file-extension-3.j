   ext 'http://example.com/download/tar.gz'
.gz
   ext 'CharacterModel.3DS'
.3DS

   Examples=: 'http://example.com/download.tar.gz';'CharacterModel.3DS';'.desktop';'document';'document.txt_backup';'/etc/pam.d/login'
   ext each Examples
┌───┬────┬────────┬┬┬┐
│.gz│.3DS│.desktop││││
└───┴────┴────────┴┴┴┘
