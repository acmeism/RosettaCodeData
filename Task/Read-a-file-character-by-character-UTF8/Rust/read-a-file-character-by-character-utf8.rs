use std::{
    convert::TryFrom,
    fmt::{Debug, Display, Formatter},
    io::Read,
};

pub struct ReadUtf8<I: Iterator> {
    source: std::iter::Peekable<I>,
}

impl<R: Read> From<R> for ReadUtf8<std::io::Bytes<R>> {
    fn from(source: R) -> Self {
        ReadUtf8 {
            source: source.bytes().peekable(),
        }
    }
}

impl<I, E> Iterator for ReadUtf8<I>
where
    I: Iterator<Item = Result<u8, E>>,
{
    type Item = Result<char, Error<E>>;

    fn next(&mut self) -> Option<Self::Item> {
        self.source.next().map(|next| match next {
            Ok(lead) => self.complete_char(lead),
            Err(e) => Err(Error::SourceError(e)),
        })
    }
}

impl<I, E> ReadUtf8<I>
where
    I: Iterator<Item = Result<u8, E>>,
{
    fn continuation(&mut self) -> Result<u32, Error<E>> {
        if let Some(Ok(byte)) = self.source.peek() {
            let byte = *byte;

            return if byte & 0b1100_0000 == 0b1000_0000 {
                self.source.next();
                Ok((byte & 0b0011_1111) as u32)
            } else {
                Err(Error::InvalidByte(byte))
            };
        }

        match self.source.next() {
            None => Err(Error::InputTruncated),
            Some(Err(e)) => Err(Error::SourceError(e)),
            Some(Ok(_)) => unreachable!(),
        }
    }

    fn complete_char(&mut self, lead: u8) -> Result<char, Error<E>> {
        let a = lead as u32; // Let's name the bytes in the sequence

        let result = if a & 0b1000_0000 == 0 {
            Ok(a)
        } else if lead & 0b1110_0000 == 0b1100_0000 {
            let b = self.continuation()?;
            Ok((a & 0b0001_1111) << 6 | b)
        } else if a & 0b1111_0000 == 0b1110_0000 {
            let b = self.continuation()?;
            let c = self.continuation()?;
            Ok((a & 0b0000_1111) << 12 | b << 6 | c)
        } else if a & 0b1111_1000 == 0b1111_0000 {
            let b = self.continuation()?;
            let c = self.continuation()?;
            let d = self.continuation()?;
            Ok((a & 0b0000_0111) << 18 | b << 12 | c << 6 | d)
        } else {
            Err(Error::InvalidByte(lead))
        };

        Ok(char::try_from(result?).unwrap())
    }
}

#[derive(Debug, Clone)]
pub enum Error<E> {
    InvalidByte(u8),
    InputTruncated,
    SourceError(E),
}

impl<E: Display> Display for Error<E> {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::InvalidByte(b) => write!(f, "invalid byte 0x{:x}", b),
            Self::InputTruncated => write!(f, "character truncated"),
            Self::SourceError(e) => e.fmt(f),
        }
    }
}

fn main() -> std::io::Result<()> {
    for (index, value) in ReadUtf8::from(std::fs::File::open("test.txt")?).enumerate() {
        match value {
            Ok(c) => print!("{}", c),

            Err(e) => {
                print!("\u{fffd}");
                eprintln!("offset {}: {}", index, e);
            }
        }
    }

    Ok(())
}
