function pso_init(y) {
  var nDims= y.min.length;
  var pos=[], vel=[], bpos=[], bval=[];
  for (var j= 0; j<y.nParticles; j++) {
    pos[j]= bpos[j]= y.min;
    var v= []; for (var k= 0; k<nDims; k++) v[k]= 0;
    vel[j]= v;
    bval[j]= Infinity}
  return {
	iter: 0,
	gbpos: Infinity,
	gbval: Infinity,
	min: y.min,
	max: y.max,
	parameters: y.parameters,
	pos: pos,
	vel: vel,
	bpos: bpos,
	bval: bval,
        nParticles: y.nParticles,
        nDims: nDims}
}

function pso(fn, state) {
  var y= state;
  var p= y.parameters;
  var val=[], bpos=[], bval=[], gbval= Infinity, gbpos=[];
  for (var j= 0; j<y.nParticles; j++) {
    // evaluate
    val[j]= fn.apply(null, y.pos[j]);
    // update
    if (val[j] < y.bval[j]) {
      bpos[j]= y.pos[j];
      bval[j]= val[j];
    } else {
      bpos[j]= y.bpos[j];
      bval[j]= y.bval[j]}
    if (bval[j] < gbval) {
      gbval= bval[j];
      gbpos= bpos[j]}}
  var rg= Math.random(), vel=[], pos=[];
  for (var j= 0; j<y.nParticles; j++) {
    // migrate
    var rp= Math.random(), ok= true;
    vel[j]= [];
    pos[j]= [];
    for (var k= 0; k < y.nDims; k++) {
      vel[j][k]= p.omega*y.vel[j][k] + p.phip*rp*(bpos[j]-y.pos[j]) + p.phig*rg*(gbpos-y.pos[j]);
      pos[j][k]= y.pos[j]+vel[j][k];
      ok= ok && y.min[k]<pos[j][k] && y.max>pos[j][k];}
    if (!ok)
      for (var k= 0; k < y.nDims; k++)
        pos[j][k]= y.min[k] + (y.max[k]-y.min[k])*Math.random()}
  return {
	iter: 1+y.iter,
	gbpos: gbpos,
	gbval: gbval,
	min: y.min,
	max: y.max,
	parameters: y.parameters,
	pos: pos,
	vel: vel,
	bpos: bpos,
	bval: bval,
        nParticles: y.nParticles,
        nDims: y.nDims}
}

function display(text) {
  if (document) {
    var o= document.getElementById('o');
    if (!o) {
      o= document.createElement('pre');
      o.id= 'o';
      document.body.appendChild(o)}
    o.innerHTML+= text+'\n';
    window.scrollTo(0,document.body.scrollHeight);
  }
  if (console.log) console.log(text)
}

function reportState(state) {
  var y= state;
  display('');
  display('Iteration: '+y.iter);
  display('GlobalBestPosition: '+y.gbpos);
  display('GlobalBestValue: '+y.gbval);
}

function repeat(fn, n, y) {
  var r=y, old= y;
  if (Infinity == n)
    while ((r= fn(r)) != old) old= r;
  else
    for (var j= 0; j<n; j++) r= fn(r);
  return r
}

function mccormick(a,b) {
  return Math.sin(a+b) + Math.pow(a-b,2) + (1 + 2.5*b - 1.5*a)
}

state= pso_init({
  min: [-1.5,-3], max:[4,4],
  parameters: {omega: 0, phip: 0.6, phig: 0.3},
  nParticles: 100});

reportState(state);

state= repeat(function(y){return pso(mccormick,y)}, 40, state);

reportState(state);
