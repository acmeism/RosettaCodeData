'''Chinese zodiac'''

from functools import (reduce)
from datetime import datetime


# TRADITIONAL STRINGS -------------------------------------

# zodiacNames :: Dict
def zodiacNames():
    '''天干 tiangan – 10 heavenly stems
       地支 dizhi – 12 terrestrial branches
       五行 wuxing – 5 elements
       生肖 shengxiao – 12 symbolic animals
       阴阳 yinyang - dark and light
    '''
    return dict(
        zip(
            ['tian', 'di', 'wu', 'sx', 'yy'],
            map(
                lambda tpl: list(
                    zip(* [tpl[0]] + list(
                        map(
                            lambda x: x.split(),
                            tpl[1:])
                    ))
                ),
                [
                    # 天干 tiangan – 10 heavenly stems
                    ('甲乙丙丁戊己庚辛壬癸',
                     'jiă yĭ bĭng dīng wù jĭ gēng xīn rén gŭi'),

                    # 地支 dizhi – 12 terrestrial branches
                    ('子丑寅卯辰巳午未申酉戌亥',
                     'zĭ chŏu yín măo chén sì wŭ wèi shēn yŏu xū hài'),

                    # 五行 wuxing – 5 elements
                    ('木火土金水',
                     'mù huǒ tǔ jīn shuǐ',
                     'wood fire earth metal water'),

                    # 十二生肖 shengxiao – 12 symbolic animals
                    ('鼠牛虎兔龍蛇馬羊猴鸡狗豬',
                     'shǔ niú hǔ tù lóng shé mǎ yáng hóu jī gǒu zhū',
                     'rat ox tiger rabbit dragon snake horse goat ' +
                     'monkey rooster dog pig'
                     ),

                    # 阴阳 yinyang
                    ('阳阴', 'yáng yīn')
                ]
            )))


# zodiacYear :: Dict -> [[String]]
def zodiacYear(dct):
    '''A string of strings containing the
       Chinese zodiac tokens for a given year.
    '''
    def tokens(y):
        iYear = y - 4
        iStem = iYear % 10
        iBranch = iYear % 12
        (hStem, pStem) = dct['tian'][iStem]
        (hBranch, pBranch) = dct['di'][iBranch]
        yy = iYear % 2
        return [
            [str(y), '', ''],
            [
                hStem + hBranch,
                pStem + pBranch,
                str((iYear % 60) + 1) + '/60'
            ],
            list(dct['wu'][iStem // 2]),
            list(dct['sx'][iBranch]),
            list(dct['yy'][int(yy)]) + ['dark' if yy else 'light']
        ]
    return lambda year: tokens(year)


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Writing out wiki tables displaying Chinese zodiac
       details for a given list of years.
    '''
    print('\n'.join(
        list(map(
            zodiacTable(zodiacNames()),
            [
                1935, 1938, 1949,
                1968, 1972, 1976,
                datetime.now().year
            ]
        ))
    ))


# WIKI TABLES  --------------------------------------------

# zodiacTable :: Dict -> Int -> String
def zodiacTable(tokens):
    '''A wiki table displaying Chinese zodiac
       details for a a given year.
    '''
    return lambda y: wikiTable({
        'class': 'wikitable',
        'colwidth': '70px'
    })(transpose(zodiacYear(tokens)(y)))


# wikiTable :: Dict -> [[a]] -> String
def wikiTable(opts):
    '''List of lists rendered as a wiki table string.'''
    def colWidth():
        return 'width:' + opts['colwidth'] + '; ' if (
            'colwidth' in opts
        ) else ''

    def cellStyle():
        return opts['cell'] if 'cell' in opts else ''

    return lambda rows: '{| ' + reduce(
        lambda a, k: (
            a + k + '="' + opts[k] + '" ' if k in opts else a
        ),
        ['class', 'style'],
        ''
    ) + '\n' + '\n|-\n'.join(
        '\n'.join(
            ('|' if (0 != i and ('cell' not in opts)) else (
                '|style="' + colWidth() + cellStyle() + '"|'
            )) + (
                str(x) or ' '
            ) for x in row
        ) for i, row in enumerate(rows)
    ) + '\n|}\n\n'


# GENERIC -------------------------------------------------

# transpose :: Matrix a -> Matrix a
def transpose(m):
    '''The rows and columns of the argument transposed.
       (The matrix containers and rows can be lists or tuples).'''
    if m:
        inner = type(m[0])
        z = zip(*m)
        return (type(m))(
            map(inner, z) if tuple != inner else z
        )
    else:
        return m


# MAIN ---
if __name__ == '__main__':
    main()
