use 5.012;
use warnings;
use utf8;
use open qw(:encoding(utf-8) :std);
use Getopt::Long;

package Game {
    use List::Util qw(shuffle first);

    my $turns        = 0;
    my %human_choice = ( rock => 0, paper => 0, scissors => 0, );
    my %comp_choice  = ( rock => 0, paper => 0, scissors => 0, );
    my %what_beats =
      ( rock => 'paper', paper => 'scissors', scissors => 'rock', );
    my $comp_wins  = 0;
    my $human_wins = 0;
    my $draws      = 0;

    sub save_human_choice {
        my $ch = lc pop;
        if ( exists $human_choice{ $ch } ) {
            ++$human_choice{ $ch };
        }
        else {
            die __PACKAGE__ . ":: wrong choice: '$ch'";
        }
    }

    sub get_comp_choice {
        my @keys = shuffle keys %human_choice;
        my $ch;
        my ( $prob, $rand ) = ( 0, rand );
        $ch = ( first { $rand <= ( $prob += ( $human_choice{ $_ } / $turns ) ) } @keys )
            if $turns > 0;
        $ch //= $keys[0];
        $ch = $what_beats{ $ch };
        ++$comp_choice{ $ch };
        return $ch;
    }

    sub make_turn {
        my ( $comp_ch, $human_ch ) = ( pop(), pop() );
        ++$turns;
        if ( $what_beats{ $human_ch } eq $comp_ch ) {
            ++$comp_wins;
            return 'I win!';
        }
        elsif ( $what_beats{ $comp_ch } eq $human_ch ) {
            ++$human_wins;
            return 'You win!';
        }
        else {
            ++$draws;
            return 'Draw!';
        }
    }

    sub get_final_report {
        my $report =
            "You chose:\n"
          . "  rock     = $human_choice{rock} times,\n"
          . "  paper    = $human_choice{paper} times,\n"
          . "  scissors = $human_choice{scissors} times,\n"
          . "I chose:\n"
          . "  rock     = $comp_choice{rock} times,\n"
          . "  paper    = $comp_choice{paper} times,\n"
          . "  scissors = $comp_choice{scissors} times,\n"
          . "Turns: $turns\n"
          . "I won: $comp_wins, you won: $human_wins, draws: $draws\n";
        return $report;
    }
}

sub main {
    GetOptions( 'quiet' => \my $quiet );
    greet() if !$quiet;
    while (1) {
        print_next_line() if !$quiet;
        my $input = get_input();
        last unless $input;
        if ( $input eq 'error' ) {
            print "I don't understand!\n" if !$quiet;
            redo;
        }
        my $comp_choice = Game::get_comp_choice();
        Game::save_human_choice($input);
        my $result = Game::make_turn( $input, $comp_choice );
        describe_turn_result( $input, $comp_choice, $result )
          if !$quiet;
    }
    print Game::get_final_report();
}

sub greet {
    print "Welcome to the Rock-Paper-Scissors game!\n"
      . "Choose 'rock', 'paper' or 'scissors'\n"
      . "Enter empty line or 'quit' to quit\n";
}

sub print_next_line {
    print 'Your choice: ';
}

sub get_input {
    my $input = <>;
    print "\n" and return if !$input;    # EOF
    chomp $input;
    return if !$input or $input =~ m/\A \s* q/xi;
    return
        ( $input =~ m/\A \s* r/xi ) ? 'rock'
      : ( $input =~ m/\A \s* p/xi ) ? 'paper'
      : ( $input =~ m/\A \s* s/xi ) ? 'scissors'
      :                               'error';
}

sub describe_turn_result {
    my ( $human_ch, $comp_ch, $result ) = @_;
    print "You chose \u$human_ch, I chose \u$comp_ch. $result\n";
}

main();
