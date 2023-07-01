import ceylon.random {
    DefaultRandom,
    Random
}

Character[] lowerCaseChars = 'a'..'z';
Character[] upperCaseChars = 'A'..'Z';
Character[] numsAsChars = '0'..'9';
Character[] specialChars = "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~".sequence();
Character[] allChars = lowerCaseChars.append(upperCaseChars)
                                     .append(numsAsChars)
                                     .append(specialChars);

shared void run() {
    print("2 passwords of size 8");
    print("------");
    generatePasswords(8,2).each(print);
    print("------");
    print("5 passwords of size 12");
    print("------");
    generatePasswords(12,5).each(print);
    print("------");
    print("7 passwords of size 16");
    print("------");
    generatePasswords(16,7).each(print);
    print("------");
    print("2 passwords of size 16 exclude AiX24!~");
    print("------");
    generatePasswords(16,7,"AiX24!~".sequence()).each(print);
}

String[] generatePasswords(Integer numChars, Integer numPasswords, Character[] excludedChars=[])
    => [for (count in 1..numPasswords) generatePassword(numChars,excludedChars) ];

//The generated password(s) must include at least one lower-case letter, one upper-case letter and one character from digits and 'other'.
String generatePassword(Integer numChars, Character[] excludedChars) {
    "Must provide a password length of at least 4"
    assert(numChars >= 4);

    value random = DefaultRandom();

    value fixedPartOfPassword = passwordFragmentForRequirements(random,excludedChars);

    value randomPart =
       randomPartOfPassword{ random = random;
                             index = fixedPartOfPassword.size + 1;
                             randomPart = "";
                             numChars = numChars;
                             candidateChars = filterCharsToExclude(allChars, excludedChars); };

    value unshuffledPassword = fixedPartOfPassword + randomPart;

    assert(unshuffledPassword.string.size == numChars);

    "excluded chars contained"
    assert(! unshuffledPassword.any((char) => excludedChars.contains(char)));

    "Sizes not equal"
    assert(unshuffledPassword.size == numChars);

    value shuffledPassword =
        shuffleCharsRecursive(unshuffledPassword.string,"",unshuffledPassword.indexes().sequence());

    "Sizes not equal"
    assert(shuffledPassword.string.size == numChars);

    "set of characters not equal"
    assert(set(unshuffledPassword) == set(shuffledPassword));

    return shuffledPassword;
}

String passwordFragmentForRequirements(Random random, Character[] excludedChars)
    => String({filterAndUse(random,lowerCaseChars, excludedChars),
               filterAndUse(random,upperCaseChars,excludedChars),
               filterAndUse(random,numsAsChars,excludedChars),
               filterAndUse(random,specialChars,excludedChars)});

String randomPartOfPassword(Random random,
                            Integer index,
                            String randomPart,
                            Integer numChars,
                            Character[] candidateChars) {
    if(index <= numChars) {
        value candidateCharsIndex = random.nextInteger(candidateChars.size);
        assert(exists allChar = candidateChars[candidateCharsIndex]);
        return randomPartOfPassword{ random=random;
                                     index=index+1;
                                     randomPart = randomPart + allChar.string;
                                     numChars =numChars;
                                     candidateChars = candidateChars; };
    }

    return randomPart;
}

String shuffleCharsRecursive(String orig,String shuffledString,Integer[] remainingOrigIndexes) {
    value random = DefaultRandom();

    if (nonempty constRemainingIndexes = remainingOrigIndexes) {
        value randomIndex = random.nextInteger(orig.size);

        assert(exists nextChar = orig[randomIndex]);

        String newShuffledString;
        Integer[] newRemainingIndexes;

        if (constRemainingIndexes.contains(randomIndex)) {
            newShuffledString = shuffledString + nextChar.string;
            newRemainingIndexes = constRemainingIndexes.filter((index) => randomIndex != index).sequence();
        } else {
            newShuffledString = shuffledString;
            newRemainingIndexes = constRemainingIndexes;
        }

        return shuffleCharsRecursive{ orig=orig;
                                      shuffledString=newShuffledString;
                                      remainingOrigIndexes=newRemainingIndexes; };
    }

    return shuffledString;
}

Character filterAndUse(Random random, Character[] chars, Character[] excludedChars) {
    value charsToUse = filterCharsToExclude(chars, excludedChars);
    value charToUseIndex = random.nextInteger(charsToUse.size);
    assert( exists charToUse = charsToUse[charToUseIndex]);
    return charToUse;
}

Character[] filterCharsToExclude(Character[] chars, Character[] charsToExclude)
    => chars.filter((char) => ! charsToExclude.contains(char)).sequence();
