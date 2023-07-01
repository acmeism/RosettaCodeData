enum Action { once, every, die }

immutable struct T {
    string anim;
    Action act;
    string phrase;
}

immutable T[10] animals = [
    T("horse",  Action.die,   "She's dead, of course!"),
    T("donkey", Action.once,  "It was rather wonky. To swallow a donkey."),
    T("cow",    Action.once,  "I don't know how. To swallow a cow."),
    T("goat",   Action.once,  "She just opened her throat. To swallow a goat."),
    T("pig",    Action.once,  "Her mouth was so big. To swallow a pig."),
    T("dog",    Action.once,  "What a hog. To swallow a dog."),
    T("cat",    Action.once,  "Fancy that. To swallow a cat."),
    T("bird",   Action.once,  "Quite absurd. To swallow a bird."),
    T("spider", Action.once,  "That wriggled and jiggled and tickled inside her."),
    T("fly",    Action.every, "I don't know why she swallowed the fly.")];

void main() {
    import std.stdio;

    foreach_reverse (immutable i; 0 .. animals.length) {
        writeln("I know an old lady who swallowed a ",
                animals[i].anim, ".");
        animals[i].phrase.writeln;

        if (animals[i].act == Action.die)
            break;

        foreach (immutable j, immutable r; animals[i + 1 .. $]) {
            writeln("She swallowed the ", animals[i + j].anim,
                    " to catch the ", r.anim, ".");
            if (r.act == Action.every)
                r.phrase.writeln;
        }

        "Perhaps she'll die.\n".writeln;
    }
}
