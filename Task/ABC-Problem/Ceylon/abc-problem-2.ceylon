shared void run() {
    printAndCanMakeWord("A", blocks);
    //True
    printAndCanMakeWord("BARK", blocks);
    //True
    printAndCanMakeWord("BOOK", blocks);
    //False
    printAndCanMakeWord("TREAT", blocks);
    //True
    printAndCanMakeWord("COMMON", blocks);
    //False
    printAndCanMakeWord("SQUAD", blocks);
    //True
    printAndCanMakeWord("CONFUSE", blocks);
    //True
}

Block[] blocks =
    [
        Block('B','O'),
        Block('X','K'),
        Block('D','Q'),
        Block('C','P'),
        Block('N','A'),
        Block('G','T'),
        Block('R','E'),
        Block('T','G'),
        Block('Q','D'),
        Block('F','S'),
        Block('J','W'),
        Block('H','U'),
        Block('V','I'),
        Block('A','N'),
        Block('O','B'),
        Block('E','R'),
        Block('F','S'),
        Block('L','Y'),
        Block('P','C'),
        Block('Z','M')
    ];

void printAndCanMakeWord(String word, Block[] blocks) {
    print("``word``:``canMakeWord(word, blocks)``");
}

class Block(Character firstLetter, Character secondLetter) {
    shared Character firstLetterUpper = firstLetter.uppercased;
    shared Character secondLetterUpper = secondLetter.uppercased;

    shared Boolean containsLetter(Character letter)
        => let (letterUpper = letter.uppercased)
            firstLetterUpper == letterUpper || secondLetterUpper == letterUpper;

    shared actual String string = "``firstLetterUpper``,``secondLetterUpper``";
}

Boolean canMakeWord(String word, Block[] blocks)
    => canMakeWordRecursive(word.uppercased.sequence(), 0, blocks, word.indexes());

Boolean canMakeWordRecursive(Character[] word,
                             Integer index,
                             Block[] remainingBlocks,
                             Integer[] remainingLetterIndexes)
    => if (exists wordFirst = word.first, // first is the Ceylon attribute for head
           exists remainingBlock = remainingBlocks.find((remainingBlock) => remainingBlock.containsLetter(wordFirst)))
        then
            let (myRemainingLetterIndexes = remainingLetterIndexes.filter((theIndex) => index != theIndex).sequence())
             if (myRemainingLetterIndexes.empty)
                 then true
                 else canMakeWordRecursive(word.rest,// rest is the Ceylon attribute for tail
                                           index+1, // move through the letter indexes
                                           remainingBlocks.filter((block) => remainingBlock != block).sequence(), // one less block
                                           myRemainingLetterIndexes)
        else false;
