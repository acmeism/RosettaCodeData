import ceylon.random {
    Random,
    DefaultRandom
}

abstract class Feature() of Color | Symbol | NumberOfSymbols | Shading {}

abstract class Color()
        of red | green | purple
        extends Feature() {}
object red extends Color() {
    string => "red";
}
object green extends Color() {
    string => "green";
}
object purple extends Color() {
    string => "purple";
}

abstract class Symbol()
        of oval | squiggle | diamond
        extends Feature() {}
object oval extends Symbol() {
    string => "oval";
}
object squiggle extends Symbol() {
    string => "squiggle";
}
object diamond extends Symbol() {
    string => "diamond";
}

abstract class NumberOfSymbols()
        of one | two | three
        extends Feature() {}
object one extends NumberOfSymbols() {
    string => "one";
}
object two extends NumberOfSymbols() {
    string => "two";
}
object three extends NumberOfSymbols() {
    string => "three";
}

abstract class Shading()
        of solid | open | striped
        extends Feature() {}
object solid extends Shading() {
    string => "solid";
}
object open extends Shading() {
    string => "open";
}
object striped extends Shading() {
    string => "striped";
}

class Card(color, symbol, number, shading) {
    shared Color color;
    shared Symbol symbol;
    shared NumberOfSymbols number;
    shared Shading shading;

    value plural => number == one then "" else "s";
    string => "``number`` ``shading`` ``color`` ``symbol````plural``";
}

{Card*} deck = {
    for(color in `Color`.caseValues)
    for(symbol in `Symbol`.caseValues)
    for(number in `NumberOfSymbols`.caseValues)
    for(shading in `Shading`.caseValues)
    Card(color, symbol, number, shading)
};

alias CardSet => [Card+];

Boolean validSet(CardSet cards) {

    function allOrOne({Feature*} features) =>
            let(uniques = features.distinct.size)
            uniques == 3 || uniques == 1;

    return allOrOne(cards*.color) &&
            allOrOne(cards*.number) &&
            allOrOne(cards*.shading) &&
            allOrOne(cards*.symbol);
}

{CardSet*} findSets(Card* cards) =>
        cards
            .sequence()
            .combinations(3)
            .filter(validSet);

Random random = DefaultRandom();

class Mode of basic | advanced {

    shared Integer numberOfCards;
    shared Integer numberOfSets;

    shared new basic {
        numberOfCards = 9;
        numberOfSets = 4;
    }

    shared new advanced {
        numberOfCards = 12;
        numberOfSets = 6;
    }
}

[{Card*}, {CardSet*}] deal(Mode mode) {
    value randomStream = random.elements(deck);
    while(true) {
        value cards = randomStream.distinct.take(mode.numberOfCards).sequence();
        value sets = findSets(*cards);
        if(sets.size == mode.numberOfSets) {
            return [cards, sets];
        }
    }
}

shared void run() {
    value [cards, sets] = deal(Mode.basic);
    print("The cards dealt are:
           ");
    cards.each(print);
    print("
           Containing the sets:
           ");
    for(cardSet in sets) {
        cardSet.each(print);
        print("");
    }

}
