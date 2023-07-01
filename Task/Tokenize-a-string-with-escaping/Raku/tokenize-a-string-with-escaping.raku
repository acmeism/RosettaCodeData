sub tokenize ($string, :$sep!, :$esc!) {
    return $string.match(/([ <!before $sep | $esc> . | $esc . ]*)+ % $sep/)\
                  .[0].map(*.subst: /$esc )> ./, '', :g);
}

say "'$_'" for tokenize 'one^|uno||three^^^^|four^^^|^cuatro|', sep => '|', esc => '^';
