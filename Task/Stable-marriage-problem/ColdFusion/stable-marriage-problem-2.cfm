INDEX.CFM

<cfscript>
    /**
     * Let's get these crazy kids married!
     * @men.hint The men who want to get married
     */
    function doCreepyMassMarriages( required Array men ) {
        marriagesAreStable = false;
        while( !marriagesAreStable ) {
            marriagesAreStable = true;
            for( man in men ) {
                if( !man.hasSettled() ) {
                    marriagesAreStable = false;
                    sexyLady = man.getBestOfWhatIsLeft();
                    if( !sexyLady.hasSettled() || sexyLady.wouldRatherBeWith( man ) ) {
                        man.settle( sexyLady );
                    }
                }
            }
        }
        return men;
    }

    /**
     * We played God...now let's see if society is going to survive
     * @men.hint The married men
     * @women.hint The married women
     */
    function isSocietyStable( required Array men, required Array women ) {
        // loop over married men
        for( var man in arguments.men ) {
            // loop over married women
            for( var woman in arguments.women ) {
                // if the man does not prefer this woman to his current spouse, and the women
                // doesn't prefer the man to her current spouse, this is the best possible match
                if( man.wouldRatherBeWith( woman ) && woman.wouldRatherBeWith( man ) ) {
                    return false;
                }
            }
        }
        return true;
    }

    // the men
    abe = new Person( "Abe" );
    bob = new Person( "Bob" );
    col = new Person( "Col" );
    dan = new Person( "Dan" );
    ed = new Person( "Ed" );
    fred = new Person( "Fred" );
    gav = new Person( "Gav" );
    hal = new Person( "Hal" );
    ian = new Person( "Ian" );
    jon = new Person( "Jon" );

    men = [ abe, bob, col, dan, ed, fred, gav, hal, ian, jon ];

    // the women
    abi = new Person( "Abi" );
    bea = new Person( "Bea" );
    cath = new Person( "Cath" );
    dee = new Person( "Dee" );
    eve = new Person( "Eve" );
    fay = new Person( "Fay" );
    gay = new Person( "Gay" );
    hope = new Person( "Hope" );
    ivy = new Person( "Ivy" );
    jan = new Person( "Jan" );

    women = [ abi, bea, cath, dee, eve, fay, gay, hope, ivy, jan ];

    // set unrealistic expectations for the men
    abe.setUnrealisticExpectations([ abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay ]);
    bob.setUnrealisticExpectations([ cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay ]);
    col.setUnrealisticExpectations([ hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan ]);
    dan.setUnrealisticExpectations([ ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi ]);
    ed.setUnrealisticExpectations([ jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay ]);
    fred.setUnrealisticExpectations([ bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay ]);
    gav.setUnrealisticExpectations([ gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay ]);
    hal.setUnrealisticExpectations([ abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee ]);
    ian.setUnrealisticExpectations([ hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve ]);
    jon.setUnrealisticExpectations([ abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope ]);
    // set unrealistic expectations for the women
    abi.setUnrealisticExpectations([ bob, fred, jon, gav, ian, abe, dan, ed, col, hal ]);
    bea.setUnrealisticExpectations([ bob, abe, col, fred, gav, dan, ian, ed, jon, hal ]);
    cath.setUnrealisticExpectations([ fred, bob, ed, gav, hal, col, ian, abe, dan, jon ]);
    dee.setUnrealisticExpectations([ fred, jon, col, abe, ian, hal, gav, dan, bob, ed ]);
    eve.setUnrealisticExpectations([ jon, hal, fred, dan, abe, gav, col, ed, ian, bob ]);
    fay.setUnrealisticExpectations([ bob, abe, ed, ian, jon, dan, fred, gav, col, hal ]);
    gay.setUnrealisticExpectations([ jon, gav, hal, fred, bob, abe, col, ed, dan, ian ]);
    hope.setUnrealisticExpectations([ gav, jon, bob, abe, ian, dan, hal, ed, col, fred ]);
    ivy.setUnrealisticExpectations([ ian, col, hal, gav, fred, bob, abe, ed, jon, dan ]);
    jan.setUnrealisticExpectations([ ed, hal, gav, abe, bob, jon, col, ian, fred, dan ]);

    // here comes the bride, duhn, duhn, duh-duhn
    possiblyHappilyMarriedMen = doCreepyMassMarriages( men );
    // let's see who shacked up!
    for( man in possiblyHappilyMarriedMen ) {
        writeoutput( man.psychoAnalyze() & "<br />" );
    }
    // check if society is stable
    if( isSocietyStable( men, women ) ) {
        writeoutput( "Hey, look at that. Creepy social engineering works. Sort of...<br /><br />" );
    }
    // what happens if couples start swingin'?
    jon.swing( fred );
    writeoutput( "Swapping Jon and Fred's wives...will society survive?<br /><br />" );
    // check if society is still stable after the swingers
    if( !isSocietyStable( men, women ) ) {
        writeoutput( "Nope, now everything is broken. Sharing spouses doesn't work, kids.<br />" );
    }
</cfscript>
