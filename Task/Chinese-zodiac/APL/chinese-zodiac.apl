hanzi  ← '甲' '乙' '丙' '丁' '戊' '己' '庚' '辛' '壬' '癸' '子' '丑' '寅' '卯' '辰' '巳' '午' '未' '申' '酉' '戌' '亥'
pinyin ← 'jiă' 'yĭ' 'bĭng' 'dīng' 'wù' 'jĭ' 'gēng' 'xīn' 'rén' 'gŭi' 'zĭ' 'chŏu' 'yín' 'măo' 'chén' 'sì' 'wŭ' 'wèi' 'shēn' 'yŏu' 'xū' 'hài'

pinyinFor ← { pinyin /⍨ ⍵ ⍷ hanzi }

stems     ← '甲' '乙' '丙' '丁' '戊' '己' '庚' '辛' '壬' '癸'
branches  ← '子' '丑' '寅' '卯' '辰' '巳' '午' '未' '申' '酉' '戌' '亥'
animals   ← 'Rat'  'Ox'   'Tiger' 'Rabbit' 'Dragon' 'Snake' 'Horse' 'Goat' 'Monkey' 'Rooster' 'Dog' 'Pig'
elements  ← 'Wood' 'Fire' 'Earth' 'Metal'  'Water'
aspects   ← 'yang' 'yin'

position     ← { 1 + 60 | ⍵ - 4 }
item         ← { ⍺ ⌷⍨ 1 + (≢⍺) | 1 -⍨ position ⍵ }
celestial    ← { stems    item ⍵ }
terrestrial  ← { branches item ⍵ }
animal       ← { animals  item ⍵ }
aspect       ← { aspects  item ⍵ }
element      ← { elements ⌷⍨ 1+⌊2÷⍨1×⍨10 | 1 -⍨ position ⍵ }

∇vec ← cz year ; cs ; tb
    cs ← celestial year
    tb ← terrestrial year
    vec ← year, (position year), cs, tb, (pinyinFor cs), (pinyinFor tb), (element year), (animal year), (aspect year)
∇
10 1 ⍴ cz ¨ 1935 1938 1941 1944 1947 1968 1972 1976 2003 2006
