enum Traffic-Signal < Red Yellow Green Blue >;

sub message (Traffic-Signal $light) {
    with $light {
        when Red    { 'Stop!'                                       }
        when Yellow { 'Speed Up!'                                   }
        when Green  { 'Go! Go! Go!'                                 }
        when Blue   { 'Wait a minute, How did we end up in Japan?!' }
        default     { 'Whut?'                                       }
    }
}

my \Pink = 'A Happy Balloon';


for Red, Green, Blue, Pink -> $signal {
    say message $signal;
}
