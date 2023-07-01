const detectNonLetterRegexp=/[^A-ZÀ-ÞЀ-Я]/g;

function stripDiacritics(phrase:string){
    return phrase.normalize('NFD').replace(/[\u0300-\u036f]/g, "")
}

function isPalindrome(phrase:string){
    const TheLetters = stripDiacritics(phrase.toLocaleUpperCase().replace(detectNonLetterRegexp, ''));
    const middlePosition = TheLetters.length/2;
    const leftHalf = TheLetters.substr(0, middlePosition);
    const rightReverseHalf = TheLetters.substr(-middlePosition).split('').reverse().join('');
    return leftHalf == rightReverseHalf;
}

console.log(isPalindrome('Sueño que esto no es un palíndromo'))
console.log(isPalindrome('Dábale arroz a la zorra el abad!'))
console.log(isPalindrome('Я иду с мечем судия'))
