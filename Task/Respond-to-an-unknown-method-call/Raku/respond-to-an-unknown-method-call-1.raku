class Farragut {
    method FALLBACK ($name, *@rest) {
        say "{self.WHAT.raku}: $name.tc() the @rest[], full speed ahead!";
    }
}

class Sparrow is Farragut { }

Farragut.damn: 'torpedoes';
Sparrow.hoist: <Jolly Roger mateys>;
