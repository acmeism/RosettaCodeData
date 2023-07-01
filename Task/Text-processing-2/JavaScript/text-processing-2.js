// wrap up the counter variables in a closure.
function analyze_func(filename) {
    var dates_seen = {};
    var format_bad = 0;
    var records_all = 0;
    var records_good = 0;
    return function() {
        var fh = new ActiveXObject("Scripting.FileSystemObject").openTextFile(filename, 1); // 1 = for reading
        while ( ! fh.atEndOfStream) {
            records_all ++;
            var allOK = true;
            var line = fh.ReadLine();
            var fields = line.split('\t');
            if (fields.length != 49) {
                format_bad ++;
                continue;
            }

            var date = fields.shift();
            if (has_property(dates_seen, date))
                WScript.echo("duplicate date: " + date);
            else
                dates_seen[date] = 1;

            while (fields.length > 0) {
                var value = parseFloat(fields.shift());
                var flag = parseInt(fields.shift(), 10);
                if (isNaN(value) || isNaN(flag)) {
                    format_bad ++;
                }
                else if (flag <= 0) {
                    allOK = false;
                }
            }
            if (allOK)
                records_good ++;
        }
        fh.close();
        WScript.echo("total records: " + records_all);
        WScript.echo("Wrong format: " + format_bad);
        WScript.echo("records with no bad readings: " + records_good);
    }
}

function has_property(obj, propname) {
    return typeof(obj[propname]) == "undefined" ? false : true;
}

var analyze = analyze_func('readings.txt');
analyze();
