<html>
<head></head>
<body>
    <form id="form"></form>
    <br/>Possible solutions:
    <ul id="ul"></ul>
</body>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
    var questions = [
        { bools:[1,1,1,1,0,0,0,0], text:"Printer does not print" },
        { bools:[1,1,0,0,1,1,0,0], text:"A red light is flashing" },
        { bools:[1,0,1,0,1,0,1,0], text:"Printer is unrecognized" },
    ];
    var answers = [
        { bools:[0,0,1,0,0,0,0,0], text:"Check the power cable" },
        { bools:[1,0,1,0,0,0,0,0], text:"Check the printer-computer cable" },
        { bools:[1,0,1,0,1,0,1,0], text:"Ensure printer software is installed" },
        { bools:[1,1,0,0,1,1,0,0], text:"Check/replace ink" },
        { bools:[0,1,0,1,0,0,0,0], text:"Check for paper jam" },
    ]

    $(document).ready(function() {
        // Init form with questions. "Value" is a descending power of 2.
        var value = questions[0].bools.length;
        for (var i = 0; i < questions.length; i++) {
            value /= 2;
            var el = '<br /><input type="checkbox" value="' + value + '">' + questions[i].text;
            $("#form").append(el);
        }

        // Respond to a checkbox action.
        $('input:checkbox').change(function() {

            // Figure out which combination of checkboxes the user selected.
            var sum = 0;
            $('input:checkbox:checked').each(function () {
                sum += Number(this.value);
            });

            // Translate sum into an index (column #) into bools.
            var index = questions[0].bools.length - sum - 1;

            // Clear the answers.
            $('#ul').html('');

            // Add appropriate answers.
            for (var i = 0; i < answers.length; i++) {
                if (answers[i].bools[index]) {
                    $('#ul').append('<li>' + answers[i].text + '</li>')
                }
            }
        });
    });
</script>
</html>
