import Data.Array (Array, listArray, (!))

------------------- TRADITIONAL STRINGS ------------------
ats :: Array Int (Char, String)
ats =
  listArray (0, 9) $
    zip
      -- 天干 tiangan – 10 heavenly stems
      "甲乙丙丁戊己庚辛壬癸"
      (words "jiă yĭ bĭng dīng wù jĭ gēng xīn rén gŭi")

ads :: Array Int (String, String)
ads =
  listArray (0, 11) $
    zip
      -- 地支 dizhi – 12 terrestrial branches
      (chars "子丑寅卯辰巳午未申酉戌亥")
      ( words $
          "zĭ chŏu yín măo chén sì "
            <> "wŭ wèi shēn yŏu xū hài"
      )

aws :: Array Int (String, String, String)
aws =
  listArray (0, 4) $
    zip3
      -- 五行 wuxing – 5 elements
      (chars "木火土金水")
      (words "mù huǒ tǔ jīn shuǐ")
      (words "wood fire earth metal water")

axs :: Array Int (String, String, String)
axs =
  listArray (0, 11) $
    zip3
      -- 十二生肖 shengxiao – 12 symbolic animals
      (chars "鼠牛虎兔龍蛇馬羊猴鸡狗豬")
      ( words $
          "shǔ niú hǔ tù lóng shé "
            <> "mǎ yáng hóu jī gǒu zhū"
      )
      ( words $
          "rat ox tiger rabbit dragon snake "
            <> "horse goat monkey rooster dog pig"
      )

ays :: Array Int (String, String)
-- 阴阳 yinyang
ays =
  listArray (0, 1) $
    zip (chars "阳阴") (words "yáng yīn")

chars :: String -> [String]
chars = (flip (:) [] <$>)

-------------------- TRADITIONAL CYCLES ------------------
f生肖五行年份 y =
  let i年份 = y - 4
      i天干 = rem i年份 10
      i地支 = rem i年份 12
      (h天干, p天干) = ats ! i天干
      (h地支, p地支) = ads ! i地支
      (h五行, p五行, e五行) = aws ! quot i天干 2
      (h生肖, p生肖, e生肖) = axs ! i地支
      (h阴阳, p阴阳) = ays ! rem i年份 2
   in -- 汉子 Chinese characters
      [ [show y, h天干 : h地支, h五行, h生肖, h阴阳],
        -- Pinyin roman transcription
        [[], p天干 <> p地支, p五行, p生肖, p阴阳],
        -- English
        [ [],
          show (rem i年份 60 + 1) <> "/60",
          e五行,
          e生肖,
          []
        ]
      ]

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    showYear
      <$> [1935, 1938, 1968, 1972, 1976, 1984, 2017]

------------------------ FORMATTING ----------------------
fieldWidths :: [[Int]]
fieldWidths =
  [ [6, 10, 7, 8, 3],
    [6, 11, 8, 8, 4],
    [6, 11, 8, 8, 4]
  ]

showYear :: Int -> String
showYear y =
  unlines $
    ( \(ns, xs) ->
        concat $
          uncurry (`justifyLeft` ' ')
            <$> zip ns xs
    )
      <$> zip fieldWidths (f生肖五行年份 y)
  where
    justifyLeft n c s = take n (s <> replicate n c)
