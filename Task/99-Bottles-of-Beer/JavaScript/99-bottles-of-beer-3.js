// Line breaks are in HTML
function Bottles(count){
    this.count = (!!count)?count:99;
    this.knock = function(){
        var c = document.createElement('div');
        c.id="bottle-"+this.count;
        c.innerHTML = "<p>"+this.count+" bottles of beer on the wall</p>"
            +"<p>"+this.count+" bottles of beer!</p>"
            +"<p>Take one down,<br>Pass it around</p>"
            +"<p>"+(--this.count)+" bottles of beer on the wall</p><p><br></p>";
        document.body.appendChild(c);
    }
    this.sing = function(){
        while (this.count>0) { this.knock(); }
    }
}

(function(){
    var bar = new Bottles(99);
    bar.sing();
})();
