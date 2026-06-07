Rebol [
    title: "Rosetta code: Top rank per group"
    file:  %Top_rank_per_group.r3
    url:   https://rosettacode.org/wiki/Top_rank_per_group
]

top-salaries: function [
    "Display top salaries per department"
    limit [integer!]
    data  [string! ]
][
    table: copy []
    data: split-lines trim/auto data
    head: take data
    forall data [
        row: split data/1 #","
        row/3: to money! row/3
        append table row
    ]
    cols: length? row
    sort/skip/compare/reverse table cols 3 ;; sort by salary
    sort/skip/compare         table cols 4 ;; sort by department

    dep: cur: 0
    foreach [name id salary department] table [
        if department != dep [
            print ""
            print ["Department:" department]
            print "-------------------------------"
            cur: 0
            dep: department
        ]
        ++ cur
        if cur <= limit [
            printf [7 14 -10][id name salary]
        ]
    ]
]

top-salaries 3 {
    Employee Name,Employee ID,Salary,Department
    Tyler Bennett,E10297,32000,D101
    John Rappl,E21437,47000,D050
    George Woltman,E00127,53500,D101
    Adam Smith,E63535,18000,D202
    Claire Buckman,E39876,27800,D202
    David McClellan,E04242,41500,D101
    Rich Holcomb,E01234,49500,D202
    Nathan Adams,E41298,21900,D050
    Richard Potter,E43128,15900,D101
    David Motsinger,E27002,19250,D202
    Tim Sampair,E03033,27000,D101
    Kim Arlich,E10001,57000,D190
    Timothy Grove,E16398,29900,D190
}
