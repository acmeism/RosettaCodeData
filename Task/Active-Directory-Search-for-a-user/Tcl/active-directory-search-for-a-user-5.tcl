package require ldapx
set conn [ldapx::connect $BindDN $Password]
$conn traverse $Base $Filter $Attrs e {
    puts [$e get distinguishedName]
}
