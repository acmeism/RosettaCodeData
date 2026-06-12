lcs =: [: |. [: ({. #~ [: *./\ [: *./ 2 =/\ ]) >@(|. each)

test1 =: 'baabababc';'baabc';'bbabc'
test2 =: 'baabababc';'baabc';'bbazc'
test3 =: 'Sunday';'Monday';'Tuesday';'Wednesday';'Friday';'Saturday'
test4 =: 'longest';'common';'suffix'
tests =: test1;test2;test3;<test4
echo@((1{":),' -> ', 1{":@<@lcs) each tests
exit''
