struct Combo<T> {
    data_len: usize,
    chunk_len: usize,
    min: usize,
    mask: usize,
    data: Vec<T>,
}

impl<T: Clone> Combo<T> {
    fn new(chunk_len: i32, data: Vec<T>) -> Self {
        let d_len = data.len();
        let min = 2usize.pow(chunk_len as u32) - 1;
        let max = 2usize.pow(d_len as u32) - 2usize.pow((d_len - chunk_len as usize) as u32);

        Combo {
            data_len: d_len,
            chunk_len: chunk_len as usize,
            min: min,
            mask: max,
            data: data,
        }
    }

    fn get_chunk(&self) -> Vec<T> {
        let b = format!("{:01$b}", self.mask, self.data_len);
        b
           .chars()
           .enumerate()
           .filter(|&(_, e)| e == '1')
           .map(|(i, _)| self.data[i].clone())
           .collect()
    }
}

impl<T: Clone> Iterator for Combo<T> {
    type Item = Vec<T>;
    fn next(&mut self) -> Option<Self::Item> {
        while self.mask >= self.min {
            if self.mask.count_ones() == self.chunk_len as u32 {
                let res = self.get_chunk();
                self.mask -= 1;
                return Some(res);
            }
            self.mask -= 1;
        }
        None
    }
}

fn main() {
    let v1 = vec![1, 2, 3, 4, 5];
    let combo = Combo::new(3, v1);
    for c in combo.into_iter() {
        println!("{:?}", c);
    }

    let v2 = vec!("A", "B", "C", "D", "E");
    let combo = Combo::new(3, v2);
    for c in combo.into_iter() {
        println!("{:?}", c);
    }
}
