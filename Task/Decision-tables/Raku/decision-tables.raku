sub decide (@q, @s) {
    my $bit = 2 ** [+] (1,2,4...*) Z* reverse @q.map: {
	so prompt(.value ~ "? ") ~~ /:i ^y/;
    }
    say "  $_" for @s.grep(*.key +& $bit)».value || "No clue!";
}

loop {
    decide
    (
	  "Y Y Y Y N N N N" => "Printer does not print",
	  "Y Y N N Y Y N N" => "A red light is flashing",
	  "Y N Y N Y N Y N" => "Printer is unrecognised",
    ),
    (
	:2<0_0_1_0_0_0_0_0> => "Check the power cable",
	:2<1_0_1_0_0_0_0_0> => "Check the printer-computer cable",
	:2<1_0_1_0_1_0_1_0> => "Ensure printer software is installed",
	:2<1_1_0_0_1_1_0_0> => "Check/replace ink",
	:2<0_1_0_1_0_0_0_0> => "Check for paper jam",
    );
    say '';
}
