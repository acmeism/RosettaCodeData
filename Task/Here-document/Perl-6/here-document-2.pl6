my $contrived_example = 'Dylan';
sub freewheelin() {
        print q :to 'QUOTE', '-- ', qq :to 'AUTHOR';
          I'll let you be in my dream,
            if I can be in yours.
        QUOTE
                Bob $contrived_example
                AUTHOR
}

freewheelin;
