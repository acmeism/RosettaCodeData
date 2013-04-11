getImgHist=: ([: /:~ ~. ,. #/.~)@,
medianHist=: {."1 {~ [: (+/\ I. -:@(+/)) {:"1
toBW=: 255 * medianHist@getImgHist < toGray
