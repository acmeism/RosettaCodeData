# Pyramid solver
#            [151]
#         [   ] [   ]
#      [ 40] [   ] [   ]
#   [   ] [   ] [   ] [   ]
#[ X ] [ 11] [ Y ] [ 4 ] [ Z ]
#  X -Y + Z = 0

def combine( snl, snr ):

	cl = {}
	if isinstance(snl, int):
		cl['1'] = snl
	elif isinstance(snl, string):
		cl[snl] = 1
	else:
		cl.update( snl)

	if isinstance(snr, int):
		n = cl.get('1', 0)
		cl['1'] = n + snr
	elif isinstance(snr, string):
		n = cl.get(snr, 0)
		cl[snr] = n + 1
	else:
		for k,v in snr.items():
			n = cl.get(k, 0)
			cl[k] = n+v
	return cl


def constrain(nsum, vn ):
	nn = {}
	nn.update(vn)
	n = nn.get('1', 0)
	nn['1'] = n - nsum
	return nn

def makeMatrix( constraints ):
	vmap = set()
	for c in constraints:
		vmap.update( c.keys())
	vmap.remove('1')
	nvars = len(vmap)
	vmap = sorted(vmap)		# sort here so output is in sorted order
	mtx = []
	for c in constraints:
		row = []
		for vv in vmap:
			row.append(float(c.get(vv, 0)))
		row.append(-float(c.get('1',0)))
		mtx.append(row)
	
	if len(constraints) == nvars:
		print 'System appears solvable'
	elif len(constraints) < nvars:
		print 'System is not solvable - needs more constraints.'
	return mtx, vmap


def SolvePyramid( vl, cnstr ):

	vl.reverse()
	constraints = [cnstr]
	lvls = len(vl)
	for lvln in range(1,lvls):
		lvd = vl[lvln]
		for k in range(lvls - lvln):
			sn = lvd[k]
			ll = vl[lvln-1]
			vn = combine(ll[k], ll[k+1])
			if sn is None:
				lvd[k] = vn
			else:
				constraints.append(constrain( sn, vn ))

	print 'Constraint Equations:'
	for cstr in constraints:
		fset = ('%d*%s'%(v,k) for k,v in cstr.items() )
		print ' + '.join(fset), ' = 0'

	mtx,vmap = makeMatrix(constraints)

	MtxSolve(mtx)

	d = len(vmap)
	for j in range(d):
		print vmap[j],'=', mtx[j][d]


def MtxSolve(mtx):
	# Simple Matrix solver...

	mDim = len(mtx)			# dimension---
	for j in range(mDim):
		rw0= mtx[j]
		f = 1.0/rw0[j]
		for k in range(j, mDim+1):
			rw0[k] *= f
		
		for l in range(1+j,mDim):
			rwl = mtx[l]
			f = -rwl[j]
			for k in range(j, mDim+1):
				rwl[k] += f * rw0[k]

	# backsolve part ---
	for j1 in range(1,mDim):
		j = mDim - j1
		rw0= mtx[j]
		for l in range(0, j):
			rwl = mtx[l]
			f = -rwl[j]
			rwl[j]    += f * rw0[j]
			rwl[mDim] += f * rw0[mDim]

	return mtx


p = [ [151], [None,None], [40,None,None], [None,None,None,None], ['X', 11, 'Y', 4, 'Z'] ]
addlConstraint = { 'X':1, 'Y':-1, 'Z':1, '1':0 }
SolvePyramid( p, addlConstraint)
