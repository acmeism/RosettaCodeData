sub extension (Str $path --> Str) {
    $path.match(/:i ['.' <[a..z0..9]>+]? $ /).Str
}

# Testing:

printf "%-35s %-11s %-12s\n", $_, extension($_).perl, $_.IO.extension.perl
for <
    http://example.com/download.tar.gz
    CharacterModel.3DS
    .desktop
    document
    document.txt_backup
    /etc/pam.d/login
>;
