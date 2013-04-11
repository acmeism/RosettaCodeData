function Stack() {
    this.data = new Array();

    this.push  = function(element) {this.data.push(element)}
    this.pop   = function() {return this.data.pop()}
    this.empty = function() {return this.data.length == 0}
    this.peek  = function() {return this.data[0]}
}
