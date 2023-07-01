static Boolean canMakeWord(List<String> src_blocks, String word) {
    if (String.isEmpty(word)) {
        return true;
    }

    List<String> blocks = new List<String>();
    for (String block : src_blocks) {
        blocks.add(block.toUpperCase());
    }

    for (Integer i = 0; i < word.length(); i++) {
        Integer blockIndex = -1;
        String c = word.mid(i, 1).toUpperCase();

        for (Integer j = 0; j < blocks.size(); j++) {
            if (blocks.get(j).contains(c)) {
                blockIndex = j;
                break;
            }
        }

        if (blockIndex == -1) {
            return false;
        } else {
            blocks.remove(blockIndex);
        }
    }

    return true;
}

List<String> blocks = new List<String>{
    'BO', 'XK', 'DQ', 'CP', 'NA',
    'GT', 'RE', 'TG', 'QD', 'FS',
    'JW', 'HU', 'VI', 'AN', 'OB',
    'ER', 'FS', 'LY', 'PC', 'ZM'
};
System.debug('"": ' + canMakeWord(blocks, ''));
System.debug('"A": ' + canMakeWord(blocks, 'A'));
System.debug('"BARK": ' + canMakeWord(blocks, 'BARK'));
System.debug('"book": ' + canMakeWord(blocks, 'book'));
System.debug('"treat": ' + canMakeWord(blocks, 'treat'));
System.debug('"COMMON": ' + canMakeWord(blocks, 'COMMON'));
System.debug('"SQuAd": ' + canMakeWord(blocks, 'SQuAd'));
System.debug('"CONFUSE": ' + canMakeWord(blocks, 'CONFUSE'));
