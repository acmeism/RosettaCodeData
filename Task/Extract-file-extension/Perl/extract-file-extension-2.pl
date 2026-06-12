printf "%-35s %-11s\n", $_, "'".extension($_)."'"
for qw[
    http://example.com/download.tar.gz
    CharacterModel.3DS
    .desktop
    document
    document.txt_backup
    /etc/pam.d/login
];
