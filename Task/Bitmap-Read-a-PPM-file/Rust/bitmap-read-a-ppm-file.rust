parser.rs:
use super::{Color, ImageFormat};
use std::str::from_utf8;
use std::str::FromStr;

pub fn parse_version(input: &[u8]) -> nom::IResult<&[u8], ImageFormat> {
    use nom::branch::alt;
    use nom::bytes::complete::tag;
    use nom::character::complete::line_ending;
    use nom::combinator::map;
    use nom::sequence::terminated;

    // starts with P3/P6 ends with a CR/LF
    terminated(
        alt((
            map(tag("P3".as_bytes()), |_| ImageFormat::P3),
            map(tag("P6".as_bytes()), |_| ImageFormat::P6),
        )),
        line_ending,
    )(input)
}

pub fn parse_image_attributes(input: &[u8]) -> nom::IResult<&[u8], (usize, usize, usize)> {
    use nom::character::complete::line_ending;
    use nom::character::complete::{digit1, space1};
    use nom::sequence::terminated;
    use nom::sequence::tuple;

    // 3 numbers separated by spaces ends with a CR/LF
    terminated(tuple((digit1, space1, digit1, space1, digit1)), line_ending)(input).map(
        |(next_input, result)| {
            (
                next_input,
                (
                    usize::from_str_radix(from_utf8(result.0).unwrap(), 10).unwrap(),
                    usize::from_str_radix(from_utf8(result.2).unwrap(), 10).unwrap(),
                    usize::from_str_radix(from_utf8(result.4).unwrap(), 10).unwrap(),
                ),
            )
        },
    )
}

pub fn parse_color_binary(input: &[u8]) -> nom::IResult<&[u8], Color> {
    use nom::number::complete::u8 as nom_u8;
    use nom::sequence::tuple;

    tuple((nom_u8, nom_u8, nom_u8))(input).map(|(next_input, res)| {
        (
            next_input,
            Color {
                red: res.0,
                green: res.1,
                blue: res.2,
            },
        )
    })
}

pub fn parse_data_binary(input: &[u8]) -> nom::IResult<&[u8], Vec<Color>> {
    use nom::multi::many0;
    many0(parse_color_binary)(input)
}

pub fn parse_color_ascii(input: &[u8]) -> nom::IResult<&[u8], Color> {
    use nom::character::complete::{digit1, space0, space1};
    use nom::sequence::tuple;

    tuple((digit1, space1, digit1, space1, digit1, space0))(input).map(|(next_input, res)| {
        (
            next_input,
            Color {
                red: u8::from_str(from_utf8(res.0).unwrap()).unwrap(),
                green: u8::from_str(from_utf8(res.2).unwrap()).unwrap(),
                blue: u8::from_str(from_utf8(res.4).unwrap()).unwrap(),
            },
        )
    })
}

pub fn parse_data_ascii(input: &[u8]) -> nom::IResult<&[u8], Vec<Color>> {
    use nom::multi::many0;
    many0(parse_color_ascii)(input)
}


lib.rs:
extern crate nom;
extern crate thiserror;
mod parser;

use std::default::Default;
use std::fmt;
use std::io::{BufWriter, Error, Write};
use std::ops::{Index, IndexMut};
use std::{fs::File, io::Read};
use thiserror::Error;

#[derive(Copy, Clone, Default, PartialEq, Debug)]
pub struct Color {
    pub red: u8,
    pub green: u8,
    pub blue: u8,
}

#[derive(Copy, Clone, PartialEq, Debug)]
pub enum ImageFormat {
    P3,
    P6,
}

impl From<&str> for ImageFormat {
    fn from(i: &str) -> Self {
        match i.to_lowercase().as_str() {
            "p3" => ImageFormat::P3,
            "p6" => ImageFormat::P6,
            _ => unimplemented!("no other formats supported"),
        }
    }
}

impl fmt::Display for ImageFormat {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            ImageFormat::P3 => {
                write!(f, "P3")
            }
            ImageFormat::P6 => {
                write!(f, "P6")
            }
        }
    }
}

#[derive(Error, Debug)]
pub enum ImageError {
    #[error("File not found")]
    FileNotFound,
    #[error("File not readable")]
    FileNotReadable,
    #[error("Invalid header information")]
    InvalidHeader,
    #[error("Invalid information in the data block")]
    InvalidData,
    #[error("Invalid max color information")]
    InvalidMaxColor,
    #[error("File is incomplete")]
    IncompleteFile,
    #[error("unknown data store error")]
    Unknown,
}
pub struct Image {
    pub format: ImageFormat,
    pub width: usize,
    pub height: usize,
    pub data: Vec<Color>,
}

impl Image {
    #[must_use]
    pub fn new(width: usize, height: usize) -> Self {
        Self {
            format: ImageFormat::P6,
            width,
            height,
            data: vec![Color::default(); width * height],
        }
    }

    pub fn fill(&mut self, color: Color) {
        for elem in &mut self.data {
            *elem = color;
        }
    }

    /// # Errors
    ///
    /// Will return `Error` if `filename` does not exist or the user does not have
    /// permission to write to it, or the write operation fails.
    pub fn write_ppm(&self, filename: &str) -> Result<(), Error> {
        let file = File::create(filename)?;
        let mut writer = BufWriter::new(file);
        writeln!(&mut writer, "{}", self.format.to_string())?;
        writeln!(&mut writer, "{} {} 255", self.width, self.height)?;
        match self.format {
            ImageFormat::P3 => {
                writer.write_all(
                    &self
                        .data
                        .iter()
                        .flat_map(|color| {
                            vec![
                                color.red.to_string(),
                                color.green.to_string(),
                                color.blue.to_string(),
                            ]
                        })
                        .collect::<Vec<String>>()
                        .join(" ")
                        .as_bytes(),
                )?;
            }
            ImageFormat::P6 => {
                writer.write_all(
                    &self
                        .data
                        .iter()
                        .flat_map(|color| vec![color.red, color.green, color.blue])
                        .collect::<Vec<u8>>(),
                )?;
            }
        }
        Ok(())
    }

    /// # Panics
    ///
    /// Panics if the format is not P6 or P3 PPM
    /// # Errors
    ///
    /// Will return `Error` if `filename` does not exist or the user does not have
    /// permission to read it or the read operation fails, or the file format does not
    /// match the specification
    pub fn read_ppm(filename: &str) -> Result<Image, ImageError> {
        let mut file = File::open(filename).map_err(|_| ImageError::FileNotFound)?;
        let mut data: Vec<u8> = Vec::new();
        file.read_to_end(&mut data)
            .map_err(|_| ImageError::FileNotReadable)?;

        let (i, format) = parser::parse_version(&data).map_err(|_| ImageError::InvalidHeader)?;
        let (i, (width, height, max_color)) =
            parser::parse_image_attributes(i).map_err(|_| ImageError::InvalidHeader)?;

        if max_color != 255 {
            return Err(ImageError::InvalidMaxColor);
        }

        let (_, data) = match format {
            ImageFormat::P3 => parser::parse_data_ascii(i).map_err(|_| ImageError::InvalidData)?,
            ImageFormat::P6 => parser::parse_data_binary(i).map_err(|_| ImageError::InvalidData)?,
        };

        if data.len() != height * width {
            return Err(ImageError::IncompleteFile);
        };

        Ok(Image {
            format,
            width,
            height,
            data,
        })
    }
}

impl Index<(usize, usize)> for Image {
    type Output = Color;

    fn index(&self, (x, y): (usize, usize)) -> &Color {
        &self.data[x + y * self.width]
    }
}

impl IndexMut<(usize, usize)> for Image {
    fn index_mut(&mut self, (x, y): (usize, usize)) -> &mut Color {
        &mut self.data[x + y * self.width]
    }
}


use bitmap::Image;

// see read_ppm implementation in the bitmap library

pub fn main() {
    // read a PPM image, which was produced by the write-a-ppm-file task
    let image = Image::read_ppm("./test_image.ppm").unwrap();

    println!("Read using nom parsing:");
    println!("Format: {:?}", image.format);
    println!("Dimensions: {} x {}", image.height, image.width);
}
