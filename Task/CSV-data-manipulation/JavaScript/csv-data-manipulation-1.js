(function () {
    'use strict';

    // splitRegex :: Regex -> String -> [String]
    function splitRegex(rgx, s) {
        return s.split(rgx);
    }

    // lines :: String -> [String]
    function lines(s) {
        return s.split(/[\r\n]/);
    }

    // unlines :: [String] -> String
    function unlines(xs) {
        return xs.join('\n');
    }

    // macOS JavaScript for Automation version of readFile.
    // Other JS contexts will need a different definition of this function,
    // and some may have no access to the local file system at all.

    // readFile :: FilePath -> maybe String
    function readFile(strPath) {
        var error = $(),
            str = ObjC.unwrap(
                $.NSString.stringWithContentsOfFileEncodingError(
                    $(strPath)
                    .stringByStandardizingPath,
                    $.NSUTF8StringEncoding,
                    error
                )
            );
        return error.code ? error.localizedDescription : str;
    }

    // macOS JavaScript for Automation version of writeFile.
    // Other JS contexts will need a different definition of this function,
    // and some may have no access to the local file system at all.

    // writeFile :: FilePath -> String -> IO ()
    function writeFile(strPath, strText) {
        $.NSString.alloc.initWithUTF8String(strText)
            .writeToFileAtomicallyEncodingError(
                $(strPath)
                .stringByStandardizingPath, false,
                $.NSUTF8StringEncoding, null
            );
    }

    // EXAMPLE - appending a SUM column

    var delimCSV = /,\s*/g;

    var strSummed = unlines(
        lines(readFile('~/csvSample.txt'))
        .map(function (x, i) {
            var xs = x ? splitRegex(delimCSV, x) : [];

            return (xs.length ? xs.concat(
                // 'SUM' appended to first line, others summed.
                i > 0 ? xs.reduce(
                    function (a, b) {
                        return a + parseInt(b, 10);
                    }, 0
                ).toString() : 'SUM'
            ) : []).join(',');
        })
    );

    return (
        writeFile('~/csvSampleSummed.txt', strSummed),
        strSummed
    );

})();
