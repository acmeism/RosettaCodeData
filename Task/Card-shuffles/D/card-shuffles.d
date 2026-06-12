import std.container.array;
import std.random;
import std.range;
import std.stdio;

auto riffleShuffle(T)(T[] list, int flips) {
    auto newList = Array!T(list);

    for (int n=0; n<flips; n++) {
        //cut the deck at the middle +/- 10%, remove the second line of the formula for perfect cutting
        int cutPoint = newList.length / 2
                     + choice([-1, 1]) * uniform!"[]"(0, newList.length / 10);

        //split the deck
        auto left = newList[0..cutPoint];
        auto right = newList[cutPoint..$];

        newList.clear();

        while (left.length > 0 && right.length > 0) {
            //allow for imperfect riffling so that more than one card can come form the same side in a row
            //biased towards the side with more cards
            //remove the if and else and brackets for perfect riffling
            if (uniform01() >= (cast(real) left.length / right.length) / 2) {
                newList.insertAfter(newList[], right.front);
                right.popFront();
            } else {
                newList.insertAfter(newList[], left.front);
                left.popFront();
            }
        }

        //if either hand is out of cards then flip all of the other hand to the shuffled deck
        if (!left.empty) newList ~= left;
        if (!right.empty) newList ~= right;
    }
    return newList.array;
}

auto overhandShuffle(T)(T[] list, int passes) {
    auto mainHand = Array!T(list);

    for (int n=0; n<passes; n++) {
        Array!T otherHand;

        while (mainHand.length > 0) {
            //cut at up to 20% of the way through the deck
            int cutSize = uniform!"[]"(0, list.length / 5) + 1;

            Array!T temp;

            //grab the next cut up to the end of the cards left in the main hand
            for (int i=0; i<cutSize && mainHand.length>0; i++) {
                temp ~= mainHand[0];
                mainHand.linearRemove(mainHand[0..1]);
            }

            //add them to the cards in the other hand, sometimes to the front sometimes to the back
            if (uniform01() >= 0.1) {
                //front most of the time
                otherHand = temp ~ otherHand;
            } else {
                //end sometimes
                otherHand ~= temp;
            }
        }

        //move the cards back to the main hand
        mainHand = otherHand;
    }
    return mainHand.array;
}

void main() {
    auto list = iota(1,21).array;
    writeln(list);
    list = riffleShuffle(list, 10);
    writeln(list);
    writeln();

    list = iota(1,21).array;
    writeln(list);
    list = riffleShuffle(list, 1);
    writeln(list);
    writeln();

    list = iota(1,21).array;
    writeln(list);
    list = overhandShuffle(list, 10);
    writeln(list);
    writeln();

    list = iota(1,21).array;
    writeln(list);
    list = overhandShuffle(list, 1);
    writeln(list);
    writeln();

    list = iota(1,21).array;
    writeln(list);
    list.randomShuffle();
    writeln(list);
}
