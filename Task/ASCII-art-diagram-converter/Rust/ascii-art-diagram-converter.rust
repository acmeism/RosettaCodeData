use std::{borrow::Cow, io::Write};

pub type Bit = bool;

#[derive(Clone, Debug)]
pub struct Field {
    name: String,
    from: usize,
    to: usize,
}

impl Field {
    pub fn new(name: String, from: usize, to: usize) -> Self {
        assert!(from < to);
        Self { name, from, to }
    }

    pub fn name(&self) -> &str {
        &self.name
    }

    pub fn from(&self) -> usize {
        self.from
    }

    pub fn to(&self) -> usize {
        self.to
    }

    pub fn size(&self) -> usize {
        self.to - self.from
    }

    pub fn extract_bits<'a>(
        &self,
        bytes: &'a [u8],
    ) -> Option<impl Iterator<Item = (usize, Bit)> + 'a> {
        if self.to <= bytes.len() * 8 {
            Some((self.from..self.to).map(move |index| {
                let byte = bytes[index / 8];
                let bit_index = 7 - (index % 8);
                let bit_value = (byte >> bit_index) & 1 == 1;
                (index, bit_value)
            }))
        } else {
            None
        }
    }

    fn extend(&mut self, new_to: usize) {
        assert!(self.to <= new_to);
        self.to = new_to;
    }
}

trait Consume: Iterator {
    fn consume(&mut self, value: Self::Item) -> Result<Self::Item, Option<Self::Item>>
    where
        Self::Item: PartialEq,
    {
        match self.next() {
            Some(v) if v == value => Ok(v),
            Some(v) => Err(Some(v)),
            None => Err(None),
        }
    }
}

impl<T: Iterator> Consume for T {}

#[derive(Clone, Copy, Debug)]
enum ParserState {
    Uninitialized,
    ExpectBorder,
    ExpectField,
    AllowEmpty,
}

#[derive(Clone, Copy, Debug)]
pub enum ParserError {
    ParsingFailed,
    UnexpectedEnd,
    InvalidBorder,
    WrongLineWidth,
    FieldExpected,
    BadField,
}

#[derive(Debug)]
pub(crate) struct Parser {
    state: Option<ParserState>,
    width: usize,
    from: usize,
    fields: Vec<Field>,
}

impl Parser {
    #[allow(clippy::new_without_default)]
    pub fn new() -> Self {
        Self {
            state: Some(ParserState::Uninitialized),
            width: 0,
            from: 0,
            fields: Vec::new(),
        }
    }

    pub fn accept(&mut self, line: &str) -> Result<(), ParserError> {
        if let Some(state) = self.state.take() {
            let line = line.trim();

            if !line.is_empty() {
                self.state = Some(match state {
                    ParserState::Uninitialized => self.parse_border(line)?,
                    ParserState::ExpectBorder => self.accept_border(line)?,
                    ParserState::ExpectField => self.parse_fields(line)?,
                    ParserState::AllowEmpty => self.extend_field(line)?,
                });
            }

            Ok(())
        } else {
            Err(ParserError::ParsingFailed)
        }
    }

    pub fn finish(self) -> Result<Vec<Field>, ParserError> {
        match self.state {
            Some(ParserState::ExpectField) => Ok(self.fields),
            _ => Err(ParserError::UnexpectedEnd),
        }
    }

    fn parse_border(&mut self, line: &str) -> Result<ParserState, ParserError> {
        self.width = Parser::border_columns(line).map_err(|_| ParserError::InvalidBorder)?;
        Ok(ParserState::ExpectField)
    }

    fn accept_border(&mut self, line: &str) -> Result<ParserState, ParserError> {
        match Parser::border_columns(line) {
            Ok(width) if width == self.width => Ok(ParserState::ExpectField),
            Ok(_) => Err(ParserError::WrongLineWidth),
            Err(_) => Err(ParserError::InvalidBorder),
        }
    }

    fn parse_fields(&mut self, line: &str) -> Result<ParserState, ParserError> {
        let mut slots = line.split('|');
        // The first split result is the space outside of the schema
        slots.consume("").map_err(|_| ParserError::FieldExpected)?;
        let mut remaining_width = self.width * Parser::COLUMN_WIDTH;
        let mut fields_found = 0;

        loop {
            match slots.next() {
                Some(slot) if slot.is_empty() => {
                    // The only empty slot is the last one
                    if slots.next().is_some() || remaining_width != 0 {
                        return Err(ParserError::BadField);
                    }

                    break;
                }

                Some(slot) => {
                    let slot_width = slot.chars().count() + 1; // Include the slot separator
                    if remaining_width < slot_width || slot_width % Parser::COLUMN_WIDTH != 0 {
                        return Err(ParserError::BadField);
                    }

                    let name = slot.trim();

                    if name.is_empty() {
                        return Err(ParserError::BadField);
                    }

                    // An actual field slot confirmed
                    remaining_width -= slot_width;
                    fields_found += 1;
                    let from = self.from;
                    let to = from + slot_width / Parser::COLUMN_WIDTH;
                    // If the slot belongs to the same field as the last one, just extend it
                    if let Some(f) = self.fields.last_mut().filter(|f| f.name() == name) {
                        f.extend(to);
                    } else {
                        self.fields.push(Field::new(name.to_string(), from, to));
                    }

                    self.from = to;
                }

                _ => return Err(ParserError::BadField),
            }
        }

        Ok(if fields_found == 1 {
            ParserState::AllowEmpty
        } else {
            ParserState::ExpectBorder
        })
    }

    fn extend_field(&mut self, line: &str) -> Result<ParserState, ParserError> {
        let mut slots = line.split('|');
        // The first split result is the space outside of the schema
        if slots.consume("").is_ok() {
            if let Some(slot) = slots.next() {
                if slots.consume("").is_ok() {
                    let slot_width = slot.chars().count() + 1;
                    let remaining_width = self.width * Parser::COLUMN_WIDTH;
                    if slot_width == remaining_width && slot.chars().all(|c| c == ' ') {
                        self.from += self.width;
                        self.fields.last_mut().unwrap().extend(self.from);
                        return Ok(ParserState::AllowEmpty);
                    }
                }
            }
        }

        self.accept_border(line)
    }

    const COLUMN_WIDTH: usize = 3;

    fn border_columns(line: &str) -> Result<usize, Option<char>> {
        let mut chars = line.chars();

        // Read the first cell, which is mandatory
        chars.consume('+')?;
        chars.consume('-')?;
        chars.consume('-')?;
        chars.consume('+')?;
        let mut width = 1;

        loop {
            match chars.consume('-') {
                Err(Some(c)) => return Err(Some(c)),
                Err(None) => return Ok(width),
                Ok(_) => {}
            }

            chars.consume('-')?;
            chars.consume('+')?;
            width += 1;
        }
    }
}

pub struct Fields(pub Vec<Field>);

#[derive(Clone, Debug)]
pub struct ParseFieldsError {
    pub line: Option<String>,
    pub kind: ParserError,
}

impl ParseFieldsError {
    fn new(line: Option<String>, kind: ParserError) -> Self {
        Self { line, kind }
    }
}

impl std::str::FromStr for Fields {
    type Err = ParseFieldsError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut parser = Parser::new();
        for line in s.lines() {
            parser
                .accept(line)
                .map_err(|e| ParseFieldsError::new(Some(line.to_string()), e))?;
        }

        parser
            .finish()
            .map(Fields)
            .map_err(|e| ParseFieldsError::new(None, e))
    }
}

impl Fields {
    pub fn print_schema(&self, f: &mut dyn Write) -> std::io::Result<()> {
        writeln!(f, "Name          Bits    Start   End")?;
        writeln!(f, "=================================")?;
        for field in self.0.iter() {
            writeln!(
                f,
                "{:<12} {:>5}      {:>3}   {:>3}",
                field.name(),
                field.size(),
                field.from(),
                field.to() - 1 // Range is exclusive, but display it as inclusive
            )?;
        }
        writeln!(f)
    }

    pub fn print_decode(&self, f: &mut dyn Write, bytes: &[u8]) -> std::io::Result<()> {
        writeln!(f, "Input (hexadecimal octets): {:x?}", bytes)?;
        writeln!(f)?;
        writeln!(f, "Name          Size    Bit pattern")?;
        writeln!(f, "=================================")?;
        for field in self.0.iter() {
            writeln!(
                f,
                "{:<12} {:>5}    {}",
                field.name(),
                field.size(),
                field
                    .extract_bits(&bytes)
                    .map(|it| it.fold(String::new(), |mut acc, (index, bit)| {
                        // Instead of simple collect, let's print it rather with
                        // byte boundaries visible as spaces
                        if index % 8 == 0 && !acc.is_empty() {
                            acc.push(' ');
                        }
                        acc.push(if bit { '1' } else { '0' });
                        acc
                    }))
                    .map(Cow::Owned)
                    .unwrap_or_else(|| Cow::Borrowed("N/A"))
            )?;
        }

        writeln!(f)
    }
}

fn normalize(diagram: &str) -> String {
    diagram
        .lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .fold(String::new(), |mut acc, x| {
            if !acc.is_empty() {
                acc.push('\n');
            }

            acc.push_str(x);
            acc
        })
}

fn main() {
    let diagram = r"
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                      ID                       |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    QDCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    ANCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    NSCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    ARCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                   OVERSIZED                   |
        |                                               |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        | OVERSIZED |           unused                  |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        ";

    let data = b"\x78\x47\x7b\xbf\x54\x96\xe1\x2e\x1b\xf1\x69\xa4\xab\xcd\xef\xfe\xdc";

    // Normalize and print the input, there is no need and no requirement to
    // generate it from the parsed representation
    let diagram = normalize(diagram);
    println!("{}", diagram);
    println!();

    match diagram.parse::<Fields>() {
        Ok(fields) => {
            let mut stdout = std::io::stdout();
            fields.print_schema(&mut stdout).ok();
            fields.print_decode(&mut stdout, data).ok();
        }

        Err(ParseFieldsError {
            line: Some(line),
            kind: e,
        }) => eprintln!("Invalid input: {:?}\n{}", e, line),

        Err(ParseFieldsError {
            line: _,
            kind: e,
        }) => eprintln!("Could not parse the input: {:?}", e),
    }
}
