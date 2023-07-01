my @names = map { ( <PATIENT_ID LASTNAME> Z=> .list ).hash },
    ( 1001, 'Hopper'  ),
    ( 4004, 'Wirth'   ),
    ( 3003, 'Kemeny'  ),
    ( 2002, 'Gosling' ),
    ( 5005, 'Kurtz'   ),
;
my @visits = map { ( <PATIENT_ID VISIT_DATE SCORE> Z=> .list ).hash },
    ( 2002, '2020-09-10', 6.8 ),
    ( 1001, '2020-09-17', 5.5 ),
    ( 4004, '2020-09-24', 8.4 ),
    ( 2002, '2020-10-08', Nil ),
    ( 1001,         Nil , 6.6 ),
    ( 3003, '2020-11-12', Nil ),
    ( 4004, '2020-11-05', 7.0 ),
    ( 1001, '2020-11-19', 5.3 ),
;

my %v = @visits.classify: *.<PATIENT_ID>;

my @result = gather for @names -> %n {
    my @p = %v{ %n.<PATIENT_ID> }<>;

    my @dates  = @p».<VISIT_DATE>.grep: *.defined;
    my @scores = @p».<     SCORE>.grep: *.defined;

    take {
        %n,
        LAST_VISIT => ( @dates.max          if @dates  ),
        SCORE_AVG  => ( @scores.sum/@scores if @scores ),
        SCORE_SUM  => ( @scores.sum         if @scores ),
    };
}

my @out_field_names = <PATIENT_ID LASTNAME LAST_VISIT SCORE_SUM SCORE_AVG>;
my @rows = @result.sort(*.<PATIENT_ID>).map(*.{@out_field_names});
say .map({$_ // ''}).fmt('%-10s', ' | ') for @out_field_names, |@rows;
