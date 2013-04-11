try { die "Help I'm dieing!"; CATCH { note $_.uc; say "Cough, Cough, Aiee!!" } }

CATCH { note "No you're not."; say $_; }

say "Yay. I'm alive.";

die "I'm dead.";

say "Arrgh.";
