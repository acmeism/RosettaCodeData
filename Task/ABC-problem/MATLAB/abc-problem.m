function testABC
    combos = ['BO' ; 'XK' ; 'DQ' ; 'CP' ; 'NA' ; 'GT' ; 'RE' ; 'TG' ; 'QD' ; ...
        'FS' ; 'JW' ; 'HU' ; 'VI' ; 'AN' ; 'OB' ; 'ER' ; 'FS' ; 'LY' ; ...
        'PC' ; 'ZM'];
    words = {'A' 'BARK' 'BOOK' 'TREAT' 'COMMON' 'SQUAD' 'CONFUSE'};
    for k = 1:length(words)
        possible = canMakeWord(words{k}, combos);
        fprintf('Can%s make word %s.\n', char(~possible.*'NOT'), words{k})
    end
end

function isPossible = canMakeWord(word, combos)
    word = lower(word);
    combos = lower(combos);
    isPossible = true;
    k = 1;
    while isPossible && k <= length(word)
        [r, c] = find(combos == word(k), 1);
        if ~isempty(r)
            combos(r, :) = '';
        else
            isPossible = false;
        end
        k = k+1;
    end
end
