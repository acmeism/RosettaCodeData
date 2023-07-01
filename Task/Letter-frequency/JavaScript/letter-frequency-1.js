(function(txt) {

    var cs = txt.split(''),
        i = cs.length,
        dct =  {},
        c = '',
        keys;

    while (i--) {
        c = cs[i];
        dct[c] = (dct[c] || 0) + 1;
    }

    keys = Object.keys(dct);
    keys.sort();
    return keys.map(function (c) { return [c, dct[c]]; });

})("Not all that Mrs. Bennet, however, with the assistance of her five\
daughters, could ask on the subject, was sufficient to draw from her\
husband any satisfactory description of Mr. Bingley. They attacked him\
in various ways--with barefaced questions, ingenious suppositions, and\
distant surmises; but he eluded the skill of them all, and they were at\
last obliged to accept the second-hand intelligence of their neighbour,\
Lady Lucas. Her report was highly favourable. Sir William had been\
delighted with him. He was quite young, wonderfully handsome, extremely\
agreeable, and, to crown the whole, he meant to be at the next assembly\
with a large party. Nothing could be more delightful! To be fond of\
dancing was a certain step towards falling in love; and very lively\
hopes of Mr. Bingley's heart were entertained.");
