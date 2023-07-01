<script type="application/javascript;version=1.7">
var funcs = [];
for (var i = 0; i < 10; i++) {
    let (i = i) {
        funcs.push( function() { return i * i; } );
    }
}
window.alert(funcs[3]()); // alerts "9"
</script>
