my $proggie = '3 4 2 * 1 5 - 2 3 ^ ^ / +';

class RPN is Array {

    method binop(&op) { self.push: self.pop R[&op] self.pop }

    method run($p) {
        for $p.words {
            say "$_ ({self})";
            when /\d/ { self.push: $_ }
            when '+'  { self.binop: &[+] }
            when '-'  { self.binop: &[-] }
            when '*'  { self.binop: &[*] }
            when '/'  { self.binop: &[/] }
            when '^'  { self.binop: &[**] }
            default   { die "$_ is bogus" }
        }
        say self;
    }
}

RPN.new.run($proggie);
