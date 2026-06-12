#[derive(Clone, Copy, Debug)]
pub enum AsciiChar {
    Null = 0,
    StartOfHeading = 1,
    StartOfText = 2,
    EndOfText = 3,
    EndOfTransmission = 4,
    Enquiry = 5,
    Acknowledge = 6,
    Bell = 7,
    Backspace = 8,
    CharacterTabulation = 9,
    LineFeed = 10,
    LineTabulation = 11,
    FormFeed = 12,
    CarriageReturn = 13,
    ShiftOut = 14,
    ShiftIn = 15,
    DataLinkEscape = 16,
    DeviceControlOne = 17,
    DeviceControlTwo = 18,
    DeviceControlThree = 19,
    DeviceControlFour = 20,
    NegativeAcknowledge = 21,
    SynchronousIdle = 22,
    EndOfTransmissionBlock = 23,
    Cancel = 24,
    EndOfMedium = 25,
    Substitute = 26,
    Escape = 27,
    InformationSeparatorFour = 28,
    InformationSeparatorThree = 29,
    InformationSeparatorTwo = 30,
    InformationSeparatorOne = 31,
    Space = 32,
    ExclamationMark = 33,
    QuotationMark = 34,
    NumberSign = 35,
    DollarSign = 36,
    PercentSign = 37,
    Ampersand = 38,
    Apostrophe = 39,
    LeftParenthesis = 40,
    RightParenthesis = 41,
    Asterisk = 42,
    PlusSign = 43,
    Comma = 44,
    HyphenMinus = 45,
    FullStop = 46,
    Solidus = 47,
    Colon = 58,
    Semicolon = 59,
    LessThanSign = 60,
    EqualsSign = 61,
    GreaterThanSign = 62,
    QuestionMark = 63,
    CommercialAt = 64,
    LeftSquareBracket = 91,
    ReverseSolidus = 92,
    RightSquareBracket = 93,
    CircumflexAccent = 94,
    LowLine = 95,
    GraveAccent = 96,
    LeftCurlyBracket = 123,
    VerticalLine = 124,
    RightCurlyBracket = 125,
    Tilde = 126,
    Delete = 127,
}

fn main() {
    println!("Value   Control char name\n{}", "_".repeat(32));
    for i in 0_u8..=127 {
        unsafe {
            // no need to check this, it is all 0 <= c <= 127, transmute is in range
            let ch = char::from_u32_unchecked(i as u32);
            if ch.is_ascii_control() {
                let ascii: AsciiChar = std::mem::transmute::<_, AsciiChar>(i);
                println!("{:>3}      {:?}", i, ascii);
            }
        }
    }
}
