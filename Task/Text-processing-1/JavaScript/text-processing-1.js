var filename = 'readings.txt';
var show_lines = 5;
var file_stats = {
    'num_readings': 0,
    'total': 0,
    'reject_run': 0,
    'reject_run_max': 0,
    'reject_run_date': ''
};

var fh = new ActiveXObject("Scripting.FileSystemObject").openTextFile(filename, 1); // 1 = for reading
while ( ! fh.atEndOfStream) {
    var line = fh.ReadLine();
    line_stats(line, (show_lines-- > 0));
}
fh.close();

WScript.echo(
    "\nFile(s)  = " + filename + "\n" +
    "Total    = " + dec3(file_stats.total) + "\n" +
    "Readings = " + file_stats.num_readings + "\n" +
    "Average  = " + dec3(file_stats.total / file_stats.num_readings) + "\n\n" +
    "Maximum run of " + file_stats.reject_run_max +
    " consecutive false readings ends at " + file_stats.reject_run_date
);

function line_stats(line, print_line) {
    var readings = 0;
    var rejects = 0;
    var total = 0;
    var fields = line.split('\t');
    var date = fields.shift();

    while (fields.length > 0) {
        var value = parseFloat(fields.shift());
        var flag = parseInt(fields.shift(), 10);
        readings++;
        if (flag <= 0) {
            rejects++;
            file_stats.reject_run++;
        }
        else {
            total += value;
            if (file_stats.reject_run > file_stats.reject_run_max) {
                file_stats.reject_run_max = file_stats.reject_run;
                file_stats.reject_run_date = date;
            }
            file_stats.reject_run = 0;
        }
    }

    file_stats.num_readings += readings - rejects;
    file_stats.total += total;

    if (print_line) {
        WScript.echo(
            "Line: " + date + "\t" +
            "Reject: " + rejects + "\t" +
            "Accept: " + (readings - rejects) + "\t" +
            "Line_tot: " + dec3(total) + "\t" +
            "Line_avg: " + ((readings == rejects) ? "0.0" : dec3(total / (readings - rejects)))
        );
    }
}

// round a number to 3 decimal places
function dec3(value) {
    return Math.round(value * 1e3) / 1e3;
}
