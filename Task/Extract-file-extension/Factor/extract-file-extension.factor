USING: assocs formatting kernel io io.pathnames math qw
sequences ;
IN: rosetta-code.file-extension

qw{
  http://example.com/download.tar.gz
  CharacterModel.3DS
  .desktop
  document
  document.txt_backup
  /etc/pam.d/login
}

dup [ file-extension ] map zip
"Path" "| Extension" "%-35s%s\n" printf
47 [ "-" write ] times nl
[ "%-35s| %s\n" vprintf ] each
