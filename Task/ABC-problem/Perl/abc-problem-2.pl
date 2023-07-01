use Test::More tests => 8;

my @blocks1 = qw(BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM);
is(can_make_word("A",       @blocks1), 1);
is(can_make_word("BARK",    @blocks1), 1);
is(can_make_word("BOOK",    @blocks1), undef);
is(can_make_word("TREAT",   @blocks1), 1);
is(can_make_word("COMMON",  @blocks1), undef);
is(can_make_word("SQUAD",   @blocks1), 1);
is(can_make_word("CONFUSE", @blocks1), 1);

my @blocks2 = qw(US TZ AO QA);
is(can_make_word('auto', @blocks2), 1);
