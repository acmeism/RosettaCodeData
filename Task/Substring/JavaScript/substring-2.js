(function () {
    'use strict';

    //  take :: Int -> Text -> Text
    function take(n, s) {
        return s.substr(0, n);
    }

    //  drop :: Int -> Text -> Text
    function drop(n, s) {
        return s.substr(n);
    }


    // init :: Text -> Text
    function init(s) {
        var n = s.length;
        return (n > 0 ? s.substr(0, n - 1) : undefined);
    }

    // breakOn :: Text -> Text -> (Text, Text)
    function breakOn(strPattern, s) {
        var i = s.indexOf(strPattern);
        return i === -1 ? [strPattern, ''] : [s.substr(0, i), s.substr(i)];
    }


    var str = '一二三四五六七八九十';


    return JSON.stringify({

        'from n in, of m length': (function (n, m) {
            return take(m, drop(n, str));
        })(4, 3),


        'from n in, up to end' :(function (n) {
            return drop(n, str);
        })(3),


        'all but last' : init(str),


        'from matching char, of m length' : (function (pattern, s, n) {
            return take(n, breakOn(pattern, s)[1]);
        })('五', str, 3),


        'from matching string, of m length':(function (pattern, s, n) {
            return take(n, breakOn(pattern, s)[1]);
        })('六七', str, 4)

    }, null, 2);

})();
