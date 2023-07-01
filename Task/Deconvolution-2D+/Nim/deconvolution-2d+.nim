import sequtils, typetraits

type Size = uint64

type M[T: SomeNumber] = object
  dims: seq[Size]
  subsizes: seq[Size]
  data: seq[T]

####################################################################################################
# Miscellaneous.

func dotProduct[T: SomeNumber](a, b: openArray[T]): T =
  assert a.len == b.len
  for i in 0..a.high:
    result += a[i] * b[i]


####################################################################################################
# Operations on M objects.

func setDimensions(m: var M; dimensions: varargs[Size]) =

  for dim in dimensions:
    if dim == 0:
      raise newException(IndexDefect, "wrong dimension: 0")

  m.dims = @dimensions
  m.subsizes = m.dims
  for i in 0..dimensions.high:
    m.subsizes[i] = m.dims[(i+1)..^1].foldl(a * b, Size(1))

  let dlength = m.dims[0] * m.subsizes[0]
  if Size(m.data.len) != dlength:
    m.data.setLen(dlength)

#---------------------------------------------------------------------------------------------------

func initM(m: var M; dimensions: varargs[Size]) =
  m.setDimensions(dimensions)

#---------------------------------------------------------------------------------------------------

func set1DArray(m: var M; t: varargs[m.T]) =

  let minLen = min(m.data.len, t.len)
  m.data.setLen(minLen)
  m.data[0..<minLen] = t[0..<minLen]

#---------------------------------------------------------------------------------------------------

func seqToIdx(m: M; s: Size): seq[Size] =

  var acc = s
  for subsize in m.subsizes:
    result.add(acc div subsize)
    acc = acc mod subsize

#---------------------------------------------------------------------------------------------------

template size(m: M): Size = Size(m.data.len)

#---------------------------------------------------------------------------------------------------

func checkBounds(m: M; indexes: varargs[Size]): bool =

  if indexes.len > m.dims.len:
    return false

  for i, dim in indexes:
    if dim >= m.dims[i]:
      return false

  result = true

#---------------------------------------------------------------------------------------------------

func `[]`(m: M; indexes: varargs[Size]): m.T =

  if not m.checkBounds(indexes):
    raise newException(IndexDefect, "index out of range: " & $indexes)

  m.data[dotProduct(indexes, m.subsizes)]

#---------------------------------------------------------------------------------------------------

func `[]=`(m: M; indexes: varargs[int]; val: m.T) =

  if not m.checkBounds(indexes):
    raise newException(IndexDefect, "index out of range: " & $indexes)

  m.data[dotProduct(indexes, m.subsizes)] = val

#---------------------------------------------------------------------------------------------------

func `==`(a, b: M): bool = a.dims == b.dims and a.data == b.data

#---------------------------------------------------------------------------------------------------

func `$`(m: M): string = $m.data


####################################################################################################
# Convolution/deconvolution.

func convolute(h, f: M): M =
  ## Result is "g".

  var dims = h.dims
  for i in 0..dims.high:
    dims[i] += f.dims[i] - 1
  result.initM(dims)

  let bound = result.size
  for i in 0..<h.size:
    let hIndexes = h.seqToIdx(i)

    for j in 0..<f.size:
      let fIndexes = f.seqToIdx(j)
      for k in 0..dims.high:
        dims[k] = hIndexes[k] + fIndexes[k]
      let idx1d = dotProduct(dims, result.subsizes)
      if idx1d < bound:
        result.data[idx1d] += h.data[i] * f.data[j]
      else:
        break   # Bound reached.

#---------------------------------------------------------------------------------------------------

func deconvolute(g, f: M): M =
  ## Result is "h".

  var dims = g.dims
  for i, d in dims:
    if d + 1 <= f.dims[i]:
      raise newException(IndexDefect, "a dimension is zero or negative")

  for i in 0..dims.high:
    dims[i] -= f.dims[i] - 1
  result.initM(dims)

  for i in 0..<result.size:
    let iIndexes = result.seqToIdx(i)
    result.data[i] = g[iIndexes]

    for j in 0..<i:
      let jIndexes = result.seqToIdx(j)
      for k in 0..dims.high:
        dims[k] = iIndexes[k] - jIndexes[k]
      if f.checkBounds(dims):
        result.data[i] -= result.data[j] * f[dims]

    when result.T is SomeInteger:
      result.data[i] = result.data[i] div f.data[0]
    else:
      result.data[i] /= f.data[0]


####################################################################################################
# Transformation of a sequence into an M object.

func fold[T](a: seq[T]; d: var seq[Size]): auto =

  if d.len == 0:
    d.add(Size(a.len))

  when a.elementType is seq:
    if a.len == 0:
      raise newException(ValueError, "empty dimension")
    d.add(Size(a[0].len))
    for elem in a:
      if elem.len != a[0].len:
        raise newException(ValueError, "not rectangular")
    result = fold(a.foldl(a & b), d)

  else:
    if Size(a.len) != d.foldl(a * b):
      raise newException(ValueError, "not same size")
    result = a

#---------------------------------------------------------------------------------------------------

func arrtoM[T](a: T): auto =

  var dims: seq[Size]
  let d = fold(a, dims)
  var res: M[d.elementType]
  res.initM(dims)
  res.set1DArray(d)
  return res


#———————————————————————————————————————————————————————————————————————————————————————————————————

const H = @[ @[ @[-6, -8, -5,  9], @[-7,  9, -6, -8], @[ 2, -7,  9,  8] ],
             @[ @[ 7,  4,  4, -6], @[ 9,  9,  4, -4], @[-3,  7, -2, -3] ] ]

const F = @[ @[ @[-9,  5, -8], @[ 3,  5,  1] ],
             @[ @[-1, -7,  2], @[-5, -6,  6] ],
             @[ @[ 8,  5,  8], @[-2, -6, -4] ] ]

let h = arrToM(H)
let f = arrToM(F)

let g = h.convolute(f)

echo "g == f convolute h ? ", g == f.convolute(h)
echo "h == g deconv f    ? ", h == g.deconvolute(f)
echo "f == g deconv h    ? ", f == g.deconvolute(h)
echo "         f = ", f
echo "g deconv f = ", g.deconvolute(h)
