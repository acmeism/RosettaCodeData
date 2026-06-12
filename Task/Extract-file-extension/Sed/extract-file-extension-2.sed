for F in "http://example.com/download.tar.gz" "CharacterModel.3DS" ".desktop" "document" "document.txt_backup" "/etc/pam.d/login"
do
  EXT=`echo $F | sed -Ene 's:.*(\.[A-Za-z0-9]+)$:\1:p'`
  echo "$F: $EXT"
done
