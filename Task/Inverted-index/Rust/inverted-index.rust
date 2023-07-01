// Part 1: Inverted index structure

use std::{
    borrow::Borrow,
    collections::{BTreeMap, BTreeSet},
};

#[derive(Debug, Default)]
pub struct InvertedIndex<T> {
    indexed: BTreeMap<String, BTreeSet<usize>>,
    sources: Vec<T>,
}

impl<T> InvertedIndex<T> {
    pub fn add<I, V>(&mut self, source: T, tokens: I)
    where
        I: IntoIterator<Item = V>,
        V: Into<String>,
    {
        let source_id = self.sources.len();
        self.sources.push(source);
        for token in tokens {
            self.indexed
                .entry(token.into())
                .or_insert_with(BTreeSet::new)
                .insert(source_id);
        }
    }

    pub fn search<'a, I, K>(&self, tokens: I) -> impl Iterator<Item = &T>
    where
        String: Borrow<K>,
        K: Ord + ?Sized + 'a,
        I: IntoIterator<Item = &'a K>,
    {
        let mut tokens = tokens.into_iter();

        tokens
            .next()
            .and_then(|token| self.indexed.get(token).cloned())
            .and_then(|first| {
                tokens.try_fold(first, |found, token| {
                    self.indexed
                        .get(token)
                        .map(|sources| {
                            found
                                .intersection(sources)
                                .cloned()
                                .collect::<BTreeSet<_>>()
                        })
                        .filter(|update| !update.is_empty())
                })
            })
            .unwrap_or_else(BTreeSet::new)
            .into_iter()
            .map(move |source| &self.sources[source])
    }

    pub fn tokens(&self) -> impl Iterator<Item = &str> {
        self.indexed.keys().map(|it| it.as_str())
    }

    pub fn sources(&self) -> &[T] {
        &self.sources
    }
}

// Part 2: File walking and processing

use std::{
    ffi::OsString,
    fmt::{Debug, Display},
    fs::{read_dir, DirEntry, File, ReadDir},
    io::{self, stdin, Read},
    path::{Path, PathBuf},
};

#[derive(Debug)]
pub struct Files {
    dirs: Vec<ReadDir>,
}

impl Files {
    pub fn walk<P: AsRef<Path>>(path: P) -> io::Result<Self> {
        Ok(Files {
            dirs: vec![read_dir(path)?],
        })
    }
}

impl Iterator for Files {
    type Item = DirEntry;

    fn next(&mut self) -> Option<Self::Item> {
        'outer: while let Some(mut current) = self.dirs.pop() {
            while let Some(entry) = current.next() {
                if let Ok(entry) = entry {
                    let path = entry.path();
                    if !path.is_dir() {
                        self.dirs.push(current);
                        return Some(entry);
                    } else if let Ok(dir) = read_dir(path) {
                        self.dirs.push(current);
                        self.dirs.push(dir);
                        continue 'outer;
                    }
                }
            }
        }

        None // No directory left
    }
}

fn tokenize<'a>(input: &'a str) -> impl Iterator<Item = String> + 'a {
    input
        .split(|c: char| !c.is_alphanumeric())
        .filter(|token| !token.is_empty())
        .map(|token| token.to_lowercase())
}

fn tokenize_file<P: AsRef<Path>>(path: P) -> io::Result<BTreeSet<String>> {
    let mut buffer = Vec::new();
    File::open(path)?.read_to_end(&mut buffer)?;
    let text = String::from_utf8_lossy(&buffer);
    Ok(tokenize(&text).collect::<BTreeSet<_>>())
}

fn tokenize_query(input: &str) -> Vec<String> {
    let result = tokenize(input).collect::<BTreeSet<_>>();
    // Make a vector sorted by length, so that longer tokens are processed first.
    // This heuristics should narrow the resulting set faster.
    let mut result = result.into_iter().collect::<Vec<_>>();
    result.sort_by_key(|item| usize::MAX - item.len());
    result
}

// Part 3: Interactive application

fn args() -> io::Result<(OsString, BTreeSet<OsString>)> {
    let mut args = std::env::args_os().skip(1); // Skip the executable's name

    let path = args
        .next()
        .ok_or_else(|| io::Error::new(io::ErrorKind::Other, "missing path"))?;

    let extensions = args.collect::<BTreeSet<_>>();

    Ok((path, extensions))
}

fn print_hits<'a, T>(hits: impl Iterator<Item = T>)
where
    T: Display,
{
    let mut found_none = true;
    for (number, hit) in hits.enumerate() {
        println!("    [{}] {}", number + 1, hit);
        found_none = false;
    }

    if found_none {
        println!("(none)")
    }
}

fn main() -> io::Result<()> {
    let (path, extensions) = args()?;
    let mut files = InvertedIndex::<PathBuf>::default();
    let mut content = InvertedIndex::<PathBuf>::default();

    println!(
        "Indexing {:?} files in '{}'",
        extensions,
        path.to_string_lossy()
    );

    for path in Files::walk(path)?.map(|file| file.path()).filter(|path| {
        path.extension()
            .filter(|&ext| extensions.is_empty() || extensions.contains(ext))
            .is_some()
    }) {
        files.add(path.clone(), tokenize(&path.to_string_lossy()));

        match tokenize_file(&path) {
            Ok(tokens) => content.add(path, tokens),
            Err(e) => eprintln!("Skipping a file {}: {}", path.display(), e),
        }
    }

    println!(
        "Indexed {} tokens in {} files.",
        content.tokens().count(),
        content.sources.len()
    );

    // Run the query UI loop
    let mut query = String::new();

    loop {
        query.clear();
        println!("Enter search query:");
        if stdin().read_line(&mut query).is_err() || query.trim().is_empty() {
            break;
        }

        match query.trim() {
            "/exit" | "/quit" | "" => break,

            "/tokens" => {
                println!("Tokens:");
                for token in content.tokens() {
                    println!("{}", token);
                }

                println!();
            }

            "/files" => {
                println!("Sources:");
                for source in content.sources() {
                    println!("{}", source.display());
                }

                println!();
            }

            _ => {
                let query = tokenize_query(&query);
                println!();
                println!("Found hits:");
                print_hits(content.search(query.iter()).map(|it| it.display()));
                println!("Found file names:");
                print_hits(files.search(query.iter()).map(|it| it.display()));
                println!();
            }
        }
    }

    Ok(())
}
