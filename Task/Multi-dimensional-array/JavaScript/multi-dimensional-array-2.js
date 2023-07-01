function tobase(base, vals) {
  var r= 0, len= base.length;
  for (j= 0; j < len; j++) {
    r*= base[j];
    r+= vals[j];
  }
  return r;
}

function frombase(base, val) {
  var r= new Array(base.length);
  for (j= base.length-1; j>= 0; j--) {
    r[j]= val%base[j];
    val= (val-r[j])/base[j];
  }
  return r;
}
