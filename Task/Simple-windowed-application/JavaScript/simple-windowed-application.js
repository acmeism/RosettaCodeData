<html>
<head>
    <title>Simple Window Application</title>
</head>

<body>
    <br> &nbsp &nbsp &nbsp &nbsp

    <script type="text/javascript">
        var box = document.createElement('input')
        box.style.position = 'absolute';  // position it
        box.style.left = '10px';
        box.style.top = '60px';
        document.body.appendChild(box).style.border="3px solid white";
        document.body.appendChild(box).value = "There have been no clicks yet";
        document.body.appendChild(box).style['width'] = '220px';
        var clicks = 0;
        function count_clicks() {
            document.body.appendChild(box).remove()
            clicks += 1;
            document.getElementById("clicks").innerHTML = clicks;
        };
    </script>

    <button type="button" onclick="count_clicks()"> Click me</button>
    <pre><p>    Clicks: <a id="clicks">0</a> </p></pre>
</body>

</html>
