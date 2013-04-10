set result [ldap::search $conn $Base $Filter $Attrs -scope subtree]
