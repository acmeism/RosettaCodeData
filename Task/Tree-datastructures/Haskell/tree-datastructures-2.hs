test = unlines
  [ "RosettaCode"
  , "    rocks"
  , "        code"
  , "        comparison"
  , "        wiki"
  , "    mocks"
  , "        trolling"
  , "Some lists"
  , "            may"
  , "        be"
  , "    irregular"  ]

itest :: Indent String
itest = from test

ttest :: Nest String
ttest = from test
