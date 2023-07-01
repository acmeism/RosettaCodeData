try {
    die "Help I'm dieing!";
    CATCH {
        when X::AdHoc { note .Str.uc; say "Cough, Cough, Aiee!!" }
        default { note "Unexpected exception, $_!" }
    }
}

say "Yay. I'm alive.";

die "I'm dead.";

say "Arrgh.";

CATCH {
    default { note "No you're not."; say $_.Str; }
}
