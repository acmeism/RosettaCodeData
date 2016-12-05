(function (width) {
    'use strict';

    function wrapByRegex(n, s) {
        return s.match(
                RegExp('.{1,' + n + '}(\\s|$)', 'g')
            )
            .join('\n');
    }

    return wrapByRegex(width,
'Even today, with proportional fonts and compl\
ex layouts, there are still cases where you ne\
ed to wrap text at a specified column. The bas\
ic task is to wrap a paragraph of text in a si\
mple way in your language. If there is a way t\
o do this that is built-in, trivial, or provid\
ed in a standard library, show that. Otherwise\
 implement the minimum length greedy algorithm\
 from Wikipedia.'
    )

})(60);
