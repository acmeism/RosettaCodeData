(def base-year 4)
(def celestial-stems ["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])
(def terrestrial-branches ["子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"])
(def zodiac-animals ["Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig"])
(def elements ["Wood" "Fire" "Earth" "Metal" "Water"])
(def aspects ["yang" "yin"])
(def pinyin (zipmap (concat celestial-stems terrestrial-branches)
                 '("jiă" "yĭ" "bĭng" "dīng" "wù" "jĭ" "gēng" "xīn" "rén" "gŭi"
                   "zĭ" "chŏu" "yín" "măo" "chén" "sì" "wŭ" "wèi" "shēn" "yŏu" "xū" "hài")))

(defn chinese-zodiac [year]
  (let [cycle-year (- year base-year)
        cycle-position (inc (mod cycle-year 60))
        stem-number (mod cycle-year 10)
        stem-han (nth celestial-stems stem-number)
        stem-pinyin (get pinyin stem-han)
        element-number (int (Math/floor (/ stem-number 2)))
        element (nth elements element-number)
        branch-number (mod cycle-year 12)
        branch-han (nth terrestrial-branches branch-number)
        branch-pinyin (get pinyin branch-han)
        zodiac-animal (nth zodiac-animals branch-number)
        aspect-number (mod cycle-year 2)
        aspect (nth aspects aspect-number)]
    (println (format "%s: %s%s (%s-%s, %s %s; %s - cycle %s/60)"
                     year stem-han branch-han stem-pinyin branch-pinyin element zodiac-animal aspect cycle-position))))

(defn -main [& args]
  (doseq [years (map read-string args)]
    (chinese-zodiac years)))
