JSON.stringify(
  (function (
    strPrepn,
    strHoliday,
    strUnit,
    strRole,
    strProcess,
    strRecipient
  ) {
    var lstOrdinal =
      'first second third fourth fifth sixth\
           seventh eighth ninth tenth eleventh twelfth'
      .split(/\s+/),
      lngUnits = lstOrdinal.length,

      lstGoods =
      'A partridge in a pear tree.\
           Two turtle doves\
           Three french hens\
           Four calling birds\
           Five golden rings\
           Six geese a-laying\
           Seven swans a-swimming\
           Eight maids a-milking\
           Nine ladies dancing\
           Ten lords a-leaping\
           Eleven pipers piping\
           Twelve drummers drumming'
      .split(/\s{2,}/),

      lstReversed = (function () {
        var lst = lstGoods.slice(0);
        return (lst.reverse(), lst);
      })(),

      strProvenance = [strRole, strProcess, strRecipient + ':'].join(' '),

      strPenultimate = lstReversed[lngUnits - 2] + ' and',
      strFinal = lstGoods[0];

    return lstOrdinal.reduce(
      function (sofar, day, i) {
        return sofar.concat(
          [
            [
              [ // abstraction of line 1
                strPrepn,
                'the',
                lstOrdinal[i],
                strUnit,
                'of',
                strHoliday
              ].join(' '),
              strProvenance
            ].concat( // reversed descent through memory
              (i > 1 ? [lstGoods[i]] : []).concat(
                lstReversed.slice(
                  lngUnits - i,
                  lngUnits - 2
                )
              ).concat( // penultimate line ends with 'and'
                [
                  strPenultimate,
                  strFinal
                ].slice(i ? 0 : 1)
              )
            )
          ]
        );
      }, []
    );
  })(
    'On', 'Christmas', 'day', 'my true love', 'gave to', 'me'
  ), null, 2
);
