say 'Strings (👨‍👩‍👧‍👦, 🤔🇺🇸, BOGUS!) sorted: "longest" first:';
say "$_: characters:{.chars},  Unicode code points:{.codes},  UTF-8 bytes:{.encode('UTF8').bytes},  UTF-16 bytes:{.encode('UTF16').bytes}" for <👨‍👩‍👧‍👦 BOGUS! 🤔🇺🇸>.sort: -*.chars;
