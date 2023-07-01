function FIFO() {
    this.data = new Array();

    this.push  = function(element) {this.data.push(element)}
    this.pop   = function() {return this.data.shift()}
    this.empty = function() {return this.data.length == 0}

    this.enqueue = this.push;
    this.dequeue = this.pop;
}
