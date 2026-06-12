sub CopyPasta ($code) {
    my @code = $code.split("\n")>>.trim.grep: *.so;
    return "Program never ends!" unless grep { $_ eq 'Pasta!' }, @code;

    my @cb;
    my $PC = 0;
    loop {
        given @code[$PC] {
            when 'Copy'      {        @cb.push: @code[++$PC] }
            when 'CopyFile'  { $PC++; @cb.push: @code[$PC] eq 'TheF*ckingCode' ?? @code !! slurp @code[$PC] }
            when 'Duplicate' {        @cb = (flat @cb) xx @code[++$PC] }
            when 'Pasta!'    { return @cb }
            default          { return "Does not compute: @code[$PC]" }
        }
        $PC++;
    }
}

spurt 'pasta.txt', "I'm the pasta.txt file.";

(say $_ for .&CopyPasta; say '')
    for
    "Copy \nRosetta Code\n\tDuplicate\n2\n\nPasta!\nLa Vista",
    "CopyFile\npasta.txt\nDuplicate\n1\nPasta!",
    "Copy\nInvalid\n Duplicate\n1\n\nGoto\n3\nPasta!",
    "CopyFile\nTheF*ckingCode\nDuplicate\n2\nPasta!",
    "Copy\nRosetta Code\nDuplicate\n2\n\nPasta";

unlink 'pasta.txt';
