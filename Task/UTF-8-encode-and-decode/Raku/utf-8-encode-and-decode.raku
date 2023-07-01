say sprintf("%-18s %-36s|%8s| %7s |%14s | %s\n", 'Character|', 'Name', 'Ordinal', 'Unicode', 'UTF-8 encoded', 'decoded'), '-' x 100;

for < A ö Ж € 𝄞 😜 👨‍👩‍👧‍👦> -> $char {
    printf "   %-5s | %-43s | %6s | %-7s | %12s  |%4s\n", $char, $char.uninames.join(','), $char.ords.join(' '),
      ('U+' X~ $char.ords».base(16)).join(' '), $char.encode('UTF8').list».base(16).Str, $char.encode('UTF8').decode;
}
