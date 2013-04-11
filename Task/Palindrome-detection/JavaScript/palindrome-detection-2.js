String.prototype.reverse = function () {
    return this.split('').reverse().join('');
};

String.prototype.isPalindrome = function () {
    var s = this.toLowerCase().replace(/[^a-z]/g, '');
    return (s.reverse() === s);
};

('A man, a plan, a canoe, pasta, heros, rajahs, ' +
'a coloratura, maps, snipe, percale, macaroni, ' +
'a gag, a banana bag, a tan, a tag, ' +
'a banana bag again (or a camel), a crepe, pins, ' +
'Spam, a rut, a Rolo, cash, a jar, sore hats, ' +
'a peon, a canal – Panama!').isPalindrome();
