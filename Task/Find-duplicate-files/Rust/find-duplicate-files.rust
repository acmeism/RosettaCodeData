use std::{
    collections::BTreeMap,
    fs::{read_dir, File},
    hash::Hasher,
    io::Read,
    path::{Path, PathBuf},
};

type Duplicates = BTreeMap<(u64, u64), Vec<PathBuf>>;

struct DuplicateFinder {
    found: Duplicates,
    min_size: u64,
}

impl DuplicateFinder {
    fn search(path: impl AsRef<Path>, min_size: u64) -> std::io::Result<Duplicates> {
        let mut result = Self {
            found: BTreeMap::new(),
            min_size,
        };

        result.walk(path)?;
        Ok(result.found)
    }

    fn walk(&mut self, path: impl AsRef<Path>) -> std::io::Result<()> {
        let listing = read_dir(path.as_ref())?;
        for entry in listing {
            let entry = entry?;
            let path = entry.path();
            if path.is_dir() {
                self.walk(path)?;
            } else {
                self.compute_digest(&path)?;
            }
        }

        Ok(())
    }

    fn compute_digest(&mut self, file: &Path) -> std::io::Result<()> {
        let size = file.metadata()?.len();
        if size < self.min_size {
            return Ok(());
        }

        // This hasher is weak, we could otherwise use an external crate
        let mut hasher = std::collections::hash_map::DefaultHasher::default();
        let mut bytes = [0u8; 8182];
        let mut f = File::open(file)?;
        loop {
            let n = f.read(&mut bytes[..])?;
            hasher.write(&bytes[..n]);
            if n == 0 {
                break;
            }
        }

        let hash = hasher.finish();

        self.found
            .entry((size, hash))
            .or_insert_with(Vec::new)
            .push(file.to_owned());

        Ok(())
    }
}

fn main() -> std::io::Result<()> {
    let mut args = std::env::args();

    args.next(); // Skip the executable name
    let dir = args.next().unwrap_or_else(|| ".".to_owned());

    let min_size = args
        .next()
        .and_then(|arg| arg.parse::<u64>().ok())
        .unwrap_or(0u64);

    DuplicateFinder::search(dir, min_size)?
        .iter()
        .rev()
        .filter(|(_, files)| files.len() > 1)
        .for_each(|((size, _), files)| {
            println!("Size: {}", size);

            files
                .iter()
                .for_each(|file| println!("{}", file.to_string_lossy()));

            println!();
        });

    Ok(())
}
