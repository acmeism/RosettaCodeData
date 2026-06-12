#===== The state machine =====#

class StateMachine {
    class State {...}
    class Transition {...}

    has State %!state;
    has &.choose-transition is rw;

    method add-state(Str $id, &action)
    {
        %!state{$id} = State.new(:$id, :&action);
    }

    multi method add-transition(Str $from, Str $to)
    {
        %!state{$from}.implicit-next = %!state{$to};
    }

    multi method add-transition(Str $from, $id, Str $to)
    {
        %!state{$from}.explicit-next.push: Transition.new(:$id, to => %!state{$to});
    }

    method run(Str $initial-state)
    {
        my $state = %!state{$initial-state};

        loop {
            $state.action.();
            if $state.implicit-next -> $_ { $state = $_; }
            elsif $state.explicit-next -> $_ { $state = &.choose-transition.(|$_).to; }
            else { last; }
        }
    }

    class Transition {
        has $.id;
        has State $.to;
    }
    class State {
        has $.id;
        has &.action;
        has State $.implicit-next is rw;
        has Transition @.explicit-next;
    }
}


#===== Usage example: Console-based vending machine =====#

my StateMachine $machine .= new;

$machine.choose-transition = sub (*@transitions) {
    say "[{.key + 1}] {.value.id}" for @transitions.pairs;
    loop {
        my $n = val get;
        return @transitions[$n - 1] if $n ~~ Int && $n ~~ 1..@transitions;
        say "Invalid input; try again.";
    }
}

$machine.add-state("ready",     { say "Please deposit coins.";                     });
$machine.add-state("waiting",   { say "Please select a product.";                  });
$machine.add-state("dispense",  { sleep 2; say "Please remove product from tray."; });
$machine.add-state("refunding", { sleep 1; say "Refunding money...";               });
$machine.add-state("exit",      { say "Shutting down...";                          });

$machine.add-transition("ready",     "quit",    "exit");
$machine.add-transition("ready",     "deposit", "waiting");
$machine.add-transition("waiting",   "select",  "dispense");
$machine.add-transition("waiting",   "refund",  "refunding");
$machine.add-transition("dispense",  "remove",  "ready");
$machine.add-transition("refunding",            "ready");

$machine.run("ready");
