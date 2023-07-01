<script>
Array.prototype.bubblesort = function() {
    var done = false;
    while (!done) {
        done = true;
        for (var i = 1; i<this.length; i++) {
            if (this[i-1] > this[i]) {
                done = false;
                [this[i-1], this[i]] = [this[i], this[i-1]]
            }
        }
    }
    return this;
}
var my_arr = ["G", "F", "C", "A", "B", "E", "D"];
my_arr.bubblesort();
	output='';
        for (var i = 0; i < my_arr.length; i++) {
		output+=my_arr[i];	
		if (i < my_arr.length-1) output+=',';
        }
document.write(output);
</script>
