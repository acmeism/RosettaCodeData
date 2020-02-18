extern crate xml; // provided by the xml-rs crate
use xml::{name::OwnedName, reader::EventReader, reader::XmlEvent};

const DOCUMENT: &str = r#"
<Students>
  <Student Name="April" Gender="F" DateOfBirth="1989-01-02" />
  <Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />
  <Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />
  <Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">
    <Pet Type="dog" Name="Rover" />
  </Student>
  <Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />
</Students>
"#;

fn main() -> Result<(), xml::reader::Error> {
    let parser = EventReader::new(DOCUMENT.as_bytes());

    let tag_name = OwnedName::local("Student");
    let attribute_name = OwnedName::local("Name");

    for event in parser {
        match event? {
            XmlEvent::StartElement {
                name,
                attributes,
                ..
            } if name == tag_name => {
                if let Some(attribute) = attributes.iter().find(|&attr| attr.name == attribute_name) {
                    println!("{}", attribute.value);
                }
            }
            _ => (),
        }
    }
    Ok(())
}
