Array.prototype.unique = function() {
   return this.sort().reduce( (a,e) => e === a[a.length-1] ? a : (a.push(e), a), [] )
}
