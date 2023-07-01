fn cwalk(mut vis: &mut Vec<Vec<bool>>, count: &mut isize, w: usize, h: usize, y: usize, x: usize, d: usize) {
    if x == 0 || y == 0 || x == w || y == h {
        *count += 1;
        return;
    }

    vis[y][x] = true;
    vis[h - y][w - x] = true;

    if x != 0 && ! vis[y][x - 1] {
        cwalk(&mut vis, count, w, h, y, x - 1, d | 1);
    }
    if d & 1 != 0 && x < w && ! vis[y][x+1] {
        cwalk(&mut vis, count, w, h, y, x + 1, d | 1);
    }
    if y != 0 && ! vis[y - 1][x] {
        cwalk(&mut vis, count, w, h, y - 1, x, d | 2);
    }
    if d & 2 != 0 && y < h && ! vis[y + 1][x] {
        cwalk(&mut vis, count, w, h, y + 1, x, d | 2);
    }

    vis[y][x] = false;
    vis[h - y][w - x] = false;
}

fn count_only(x: usize, y: usize) -> isize {
    let mut count = 0;
    let mut w = x;
    let mut h = y;

    if (h * w) & 1 != 0 {
        return count;
    }
    if h & 1 != 0 {
        std::mem::swap(&mut w, &mut h);
    }

    let mut vis = vec![vec![false; w + 1]; h + 1];
    vis[h / 2][w / 2] = true;

    if w & 1 != 0 {
        vis[h / 2][w / 2 + 1] = true;
    }
    let mut res;
    if w > 1 {
        cwalk(&mut vis, &mut count, w, h, h / 2, w / 2 - 1, 1);
        res = 2 * count - 1;
        count = 0;
        if w != h {
            cwalk(&mut vis, &mut count, w, h, h / 2 + 1, w / 2, if w & 1 != 0 { 3 } else { 2 });
        }
        res += 2 * count - if w & 1 == 0 { 1 } else { 0 };
    }
    else {
        res = 1;
    }

    if w == h {
        res = 2 * res + 2;
    }
    res
}

fn main() {
    for y in 1..10 {
        for x in 1..y + 1 {
            if x & 1 == 0 || y & 1 == 0 {
                println!("{} x {}: {}", y, x, count_only(x, y));
            }
        }
    }
}
