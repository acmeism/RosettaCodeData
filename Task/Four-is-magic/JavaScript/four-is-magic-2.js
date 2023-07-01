const reverseOrderedNumberToTextMap = (function () {
    const rawNumberToTextMapping = { // Ported over from the Python solution.
        [1n]: "one",
        [2n]: "two",
        [3n]: "three",
        [4n]: "four",
        [5n]: "five",
        [6n]: "six",
        [7n]: "seven",
        [8n]: "eight",
        [9n]: "nine",
        [10n]: "ten",
        [11n]: "eleven",
        [12n]: "twelve",
        [13n]: "thirteen",
        [14n]: "fourteen",
        [15n]: "fifteen",
        [16n]: "sixteen",
        [17n]: "seventeen",
        [18n]: "eighteen",
        [19n]: "nineteen",
        [20n]: "twenty",
        [30n]: "thirty",
        [40n]: "forty",
        [50n]: "fifty",
        [60n]: "sixty",
        [70n]: "seventy",
        [80n]: "eighty",
        [90n]: "ninety",
        [100n]: "hundred",
        [1000n]: "thousand",
        [10n ** 6n]: "million",
        [10n ** 9n]: "billion",
        [10n ** 12n]: "trillion",
        [10n ** 15n]: "quadrillion",
        [10n ** 18n]: "quintillion",
        [10n ** 21n]: "sextillion",
        [10n ** 24n]: "septillion",
        [10n ** 27n]: "octillion",
        [10n ** 30n]: "nonillion",
        [10n ** 33n]: "decillion",
        [10n ** 36n]: "undecillion",
        [10n ** 39n]: "duodecillion",
        [10n ** 42n]: "tredecillion",
        [10n ** 45n]: "quattuordecillion",
        [10n ** 48n]: "quinquadecillion",
        [10n ** 51n]: "sedecillion",
        [10n ** 54n]: "septendecillion",
        [10n ** 57n]: "octodecillion",
        [10n ** 60n]: "novendecillion",
        [10n ** 63n]: "vigintillion",
        [10n ** 66n]: "unvigintillion",
        [10n ** 69n]: "duovigintillion",
        [10n ** 72n]: "tresvigintillion",
        [10n ** 75n]: "quattuorvigintillion",
        [10n ** 78n]: "quinquavigintillion",
        [10n ** 81n]: "sesvigintillion",
        [10n ** 84n]: "septemvigintillion",
        [10n ** 87n]: "octovigintillion",
        [10n ** 90n]: "novemvigintillion",
        [10n ** 93n]: "trigintillion",
        [10n ** 96n]: "untrigintillion",
        [10n ** 99n]: "duotrigintillion",
        [10n ** 102n]: "trestrigintillion",
        [10n ** 105n]: "quattuortrigintillion",
        [10n ** 108n]: "quinquatrigintillion",
        [10n ** 111n]: "sestrigintillion",
        [10n ** 114n]: "septentrigintillion",
        [10n ** 117n]: "octotrigintillion",
        [10n ** 120n]: "noventrigintillion",
        [10n ** 123n]: "quadragintillion",
        [10n ** 153n]: "quinquagintillion",
        [10n ** 183n]: "sexagintillion",
        [10n ** 213n]: "septuagintillion",
        [10n ** 243n]: "octogintillion",
        [10n ** 273n]: "nonagintillion",
        [10n ** 303n]: "centillion",
        [10n ** 306n]: "uncentillion",
        [10n ** 309n]: "duocentillion",
        [10n ** 312n]: "trescentillion",
        [10n ** 333n]: "decicentillion",
        [10n ** 336n]: "undecicentillion",
        [10n ** 363n]: "viginticentillion",
        [10n ** 366n]: "unviginticentillion",
        [10n ** 393n]: "trigintacentillion",
        [10n ** 423n]: "quadragintacentillion",
        [10n ** 453n]: "quinquagintacentillion",
        [10n ** 483n]: "sexagintacentillion",
        [10n ** 513n]: "septuagintacentillion",
        [10n ** 543n]: "octogintacentillion",
        [10n ** 573n]: "nonagintacentillion",
        [10n ** 603n]: "ducentillion",
        [10n ** 903n]: "trecentillion",
        [10n ** 1203n]: "quadringentillion",
        [10n ** 1503n]: "quingentillion",
        [10n ** 1803n]: "sescentillion",
        [10n ** 2103n]: "septingentillion",
        [10n ** 2403n]: "octingentillion",
        [10n ** 2703n]: "nongentillion",
        [10n ** 3003n]: "millinillion"
    };

    return new Map(Object.entries(rawNumberToTextMapping)
                         .sort((a, b) => BigInt(a[0]) > BigInt(b[0]) ? -1 : 1)
                         .map(numberAndText => [BigInt(numberAndText[0]), numberAndText[1]]));
})();


function getCardinalRepresentation(number)
{
    if (number == 0n)
    {
        return "zero";
    }

    function* generateCardinalRepresentationTokens(number)
    {
        if (number <= 0n)
        {
            yield "negative";
            number *= -1n;
        }

        for (const [currentEntryNumber, currentEntryText] of reverseOrderedNumberToTextMap.entries())
        {
            if (number >= currentEntryNumber)
            {
                if (currentEntryNumber >= 100n)
                {
                    yield* generateCardinalRepresentationTokens(number / currentEntryNumber);
                }

                yield currentEntryText;
                number -= currentEntryNumber;
            }
        }
    }


    return [...generateCardinalRepresentationTokens(number)].join(" ");
}

function* generateFourIsMagicParts(number)
{
    if (typeof number != "bigint")
    {
        number = BigInt(number);
    }

    if (number == 4n)
    {
        yield "four is magic";
    }
    else
    {
        const cardinalRepresentation = getCardinalRepresentation(number);
        yield `${cardinalRepresentation} is ${getCardinalRepresentation(BigInt(cardinalRepresentation.length))}`;
        yield* generateFourIsMagicParts(cardinalRepresentation.length);
    }

}

function capitalizeFirstLetter(str)
{
    return str.replace(/^([a-z])/, chr => chr.toUpperCase());
}

function fourIsMagic(number)
{
    return capitalizeFirstLetter(`${[...generateFourIsMagicParts(number)].join(", ")}.`);
}

[
    0,
    -150,
    210,
    10n ** 2703n + 1225n,
    4,
    -4,
    10n ** 3003n + 42n
].map(fourIsMagic).join("\n\n");
