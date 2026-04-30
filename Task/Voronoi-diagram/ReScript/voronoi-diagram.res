let n_sites = 60

let size_x = 640
let size_y = 480

let rand_int_range = (a, b) => a + Random.int(b - a + 1)

let dist_euclidean = (x, y) => { (x * x + y * y) }
let dist_minkowski = (x, y) => { (x * x * x + y * y * y) }
let dist_taxicab = (x, y) => { abs(x) + abs(y) }

let dist_f = dist_euclidean
let dist_f = dist_minkowski
let dist_f = dist_taxicab

let nearest_site = (site, x, y) => {
  let ret = ref(0)
  let dist = ref(0)
  Js.Array2.forEachi(site, ((sx, sy), k) => {
    let d = dist_f((x - sx), (y - sy))
    if (k == 0 || d < dist.contents) {
      dist.contents = d
      ret.contents = k
    }
  })
  ret.contents
}

let gen_map = (site, rgb) => {
  let nearest = Belt.Array.make((size_x * size_y), 0)
  let buf = Belt.Array.make((3 * size_x * size_y), 0)

  for y in 0 to size_y - 1 {
    for x in 0 to size_x - 1 {
      nearest[y * size_x + x] = nearest_site(site, x, y)
    }
  }

  for i in 0 to (size_y * size_x) - 1 {
    let j = i * 3
    let (r, g, b) = rgb[nearest[i]]
    buf[j+0] = r
    buf[j+1] = g
    buf[j+2] = b
  }

  Printf.printf("P3\n%d %d\n255\n", size_x, size_y)
  Js.Array2.forEach(buf, (d) => Printf.printf("%d\n", d))
}

{
  Random.self_init ();
  let site =
    Belt.Array.makeBy(n_sites, (i) => {
      (Random.int(size_x),
       Random.int(size_y))
     })

  let rgb =
    Belt.Array.makeBy(n_sites, (i) => {
      (rand_int_range( 50, 120),
       rand_int_range( 80, 180),
       rand_int_range(140, 240))
    })
  gen_map(site, rgb)
}
