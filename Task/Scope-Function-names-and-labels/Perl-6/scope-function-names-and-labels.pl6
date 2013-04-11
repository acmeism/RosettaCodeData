# call a routine before it has been defined
say log();              # prints: outer

# define a subroutine that overrides a CORE function
sub log { 'outer' };
{
    # redefine the subroutine in this block
    sub log { 'inner' };
    {
        # redefine the subroutine yet again
        sub log { 'way down inside' };

        # call it within this block
        say log();                 # prints: way down inside

        # call it from the block one level out
        say &OUTER::log();         # prints: inner

        # call it from the block two levels out
        say &OUTER::OUTER::log();  # prints: outer

        # call it from the outermost block
        say &UNIT::log();          # prints: outer

        # call a subroutine that is post declared in outermost scope
        outersub()
    }

    {
        # subroutine in an inner block that doesn't redefine it
        # uses definition from nearest enclosing block
        say log();      # prints: inner
    }
    # call it within this block
    say log();          # prints: inner

    # call it from the block one level out
    say &OUTER::log();  # prints: outer
}

sub outersub{
    # call subroutine within this block - gets outer sub
    say log();          # prints: outer

    # call subroutine from the scope of the callers block
    say &CALLER::log(); # prints: way down inside

    # call subroutine from the outer scope of the callers block
    say &CALLER::OUTER::log(); # prints: inner

    # call the original overridden CORE routine
    say &CORE::log(e);  # prints: 1 ( natural log of e )
}
