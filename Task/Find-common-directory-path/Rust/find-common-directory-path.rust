use std::path::{Path, PathBuf};

fn main() {
    let paths = [
        Path::new("/home/user1/tmp/coverage/test"),
        Path::new("/home/user1/tmp/covert/operator"),
        Path::new("/home/user1/tmp/coven/members"),
    ];
    match common_path(&paths) {
        Some(p) => println!("The common path is: {:#?}", p),
        None => println!("No common paths found"),
    }
}

fn common_path<I, P>(paths: I) -> Option<PathBuf>
where
    I: IntoIterator<Item = P>,
    P: AsRef<Path>,
{
    let mut iter = paths.into_iter();
    let mut ret = iter.next()?.as_ref().to_path_buf();
    for path in iter {
        if let Some(r) = common(ret, path.as_ref()) {
            ret = r;
        } else {
            return None;
        }
    }
    Some(ret)
}

fn common<A: AsRef<Path>, B: AsRef<Path>>(a: A, b: B) -> Option<PathBuf> {
    let a = a.as_ref().components();
    let b = b.as_ref().components();
    let mut ret = PathBuf::new();
    let mut found = false;
    for (one, two) in a.zip(b) {
        if one == two {
            ret.push(one);
            found = true;
        } else {
            break;
        }
    }
    if found {
        Some(ret)
    } else {
        None
    }
}
