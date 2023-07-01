PERSON.CFC

component displayName="Person" accessors="true" {
    property name="Name" type="string";
    property name="MrOrMrsGoodEnough" type="Person";
    property name="UnrealisticExpectations" type="array";
    property name="PersonalHistory" type="array";

    public Person function init( required String name ) {
        setName( arguments.name );
        setPersonalHistory([ getName() & " is on the market." ]);
        this.HotnessScale = 0;
        return this;
    }

    public Boolean function hasSettled() {
        // if we have settled, return true;
        return isInstanceOf( getMrOrMrsGoodEnough(), "Person" );
    }

    public Person function getBestOfWhatIsLeft() {
        // increment the hotness scale...1 is best, 10 is...well...VERY settling.
        this.HotnessScale++;
        // get the match from the current rung in the barrel
        var bestChoice = getUnrealisticExpectations()[ this.HotnessScale ];
        return bestChoice;
    }

    public Boolean function wouldRatherBeWith( required Person person ) {
        // only compare if we've already settled on a potential mate
        if( isInstanceOf( this.getMrOrMrsGoodEnough(), "Person" ) ) {
            // if the new person's hotness is greater (numerically smaller) than our current beau...
            return getHotness( this, arguments.person ) < getHotness( this, this.getMrOrMrsGoodEnough() );
        }
        return false;
    }

    public Void function settle( required Person person ) {
        if( person.hasSettled() ) {
            // this is the match we want. Force a break up of a previous relationship (sorry!)
            dumpLikeATonOfBricks( person );
        }
        person.setMrOrMrsGoodEnough( this );
        if( hasSettled() ) {
            // this is the match we want, so write a dear john to our current match
            dumpLikeATonOfBricks( this );
        }
        logHookup( arguments.person );
        // we've found the mate of our dreams!
        setMrOrMrsGoodEnough( arguments.person );
    }

    public Void function swing( required Person person ) {
        // get our spouses
        var mySpouse = getMrOrMrsGoodEnough();
        var notMySpouse = arguments.person.getMrOrMrsGoodEnough();
        // swap em'
        setMrOrMrsGoodEnough( notMySpouse );
        person.setMrOrMrsGoodEnough( mySpouse );
    }

    public Void function dumpLikeATonOfBricks( required Person person ) {
        logBreakup( arguments.person );
        person.getMrOrMrsGoodEnough().setMrOrMrsGoodEnough( JavaCast( "null", "" ) );
    }

    public String function psychoAnalyze() {
        logNuptuals();
        logRegrets();
        var personalJourney = "";
        for( var entry in getPersonalHistory() ) {
            personalJourney = personalJourney & entry & "<br />";
        }
        return personalJourney;
    }

    private Numeric function getHotness( required Person pursuer, required Person pursued ) {
        var pursuersExpectations = pursuer.getUnrealisticExpectations();
        var hotnessFactor = 1;
        for( var hotnessFactor=1; hotnessFactor<=arrayLen( pursuersExpectations ); hotnessFactor++ ) {
            if( pursuersExpectations[ hotnessFactor ].getName()==arguments.pursued.getName() ) {
                return hotnessFactor;
            }
        }
    }

    private Void function logRegrets() {
        var spouse = getMrOrMrsGoodEnough();
        var spouseHotness = getHotness( this, spouse );
        var myHotness = getHotness( spouse, this );
        if( spouseHotness == 1 && myHotness == 1 ) {
            arrayAppend( getPersonalHistory(), "Yes, yes, the beautiful people always find happy endings: #getName()# (her ###myHotness#), #spouse.getName()# (his ###spouseHotness#)");
        }
        else if( spouseHotness == myHotness ) {
            arrayAppend( getPersonalHistory(), "#getName()# (her ###myHotness#) was made for #spouse.getName()# (his ###spouseHotness#). How precious.");
        }
        else if( spouseHotness > myHotness ) {
            arrayAppend( getPersonalHistory(), "#getName()# (her ###myHotness#) could have done better than #spouse.getName()# (his ###spouseHotness#). Poor slob.");
        }
        else {
            arrayAppend( getPersonalHistory(), "#getName()# (her ###myHotness#) is a lucky bastard to have landed #spouse.getName()# (his ###spouseHotness#).");
        }
    }

    private Void function logNuptuals() {
        arrayAppend( getPersonalHistory(), "#getName()# has settled for #getMrOrMrsGoodEnough().getName()#." );
    }

    private Void function logHookup( required Person person ) {
        var winnerHotness = getHotness( this, arguments.person );
        var myHotness = getHotness( arguments.person, this );
        arrayAppend( getPersonalHistory(), "#getName()# (her ###myHotness#) is checking out #arguments.person.getName()# (his ###winnerHotness#), but wants to keep his options open.");
    }

    private Void function logBreakup( required Person person ) {
        var scrub = person.getMrOrMrsGoodEnough();
        var scrubHotness = getHotness( person, scrub );
        var myHotness = getHotness( person, this );
        arrayAppend( getPersonalHistory(), "#getName()# is so hot (her ###myHotness#) that #person.getName()# is dumping #scrub.getName()# (her ###scrubHotness#)");
    }
}
