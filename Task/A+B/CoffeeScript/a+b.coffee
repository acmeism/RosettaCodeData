<html>
<script type="text/javascript" src="http://jashkenas.github.com/coffee-script/extras/coffee-script.js"></script>
<script type="text/coffeescript">
a = window.prompt 'enter A number', ''
b = window.prompt 'enter B number', ''
document.getElementById('input').innerHTML = a + ' ' + b
sum = parseInt(a) + parseInt(b)
document.getElementById('output').innerHTML = sum
</script>
<body>
<div id='input'></div>
<div id='output'></div>
</body>
</html>
