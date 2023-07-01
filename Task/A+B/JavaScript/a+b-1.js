<html>
<body>
<div id='input'></div>
<div id='output'></div>
<script type='text/javascript'>
var a = window.prompt('enter A number', '');
var b = window.prompt('enter B number', '');
document.getElementById('input').innerHTML = a + ' ' + b;

var sum = Number(a) + Number(b);
document.getElementById('output').innerHTML = sum;
</script>
</body>
</html>
