use std::path::Path;
use std::fs;

fn truncate_file<P: AsRef<Path>>(filename: P, filesize: usize) -> Result<(), Error> {
    use Error::*;
    let file = fs::read(&filename).or(Err(NotFound))?;

    if filesize > file.len() {
        return Err(FilesizeTooSmall)
    }

    fs::write(&filename, &file[..filesize]).or(Err(UnableToWrite))?;
    Ok(())
}

#[derive(Debug)]
enum Error {
    /// File not found
    NotFound,
    /// Truncated size would be larger than the current size
    FilesizeTooSmall,
    /// Likely due to having read but not write permissions
    UnableToWrite,
}
