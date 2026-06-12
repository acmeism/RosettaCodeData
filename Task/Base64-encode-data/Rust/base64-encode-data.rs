use std::fs::File;
use std::io::{self, Read, Write}; // Import Write for stdout
use std::path::Path;
use std::error::Error;

// Base64 character set
const CHAR_SET: &'static str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
const PADDING_CHAR: char = '=';

/// Encodes a byte slice into a Base64 String.
fn encode(input_bytes: &[u8]) -> String {
    // Calculate potential output size for pre-allocation.
    // Each 3 input bytes become 4 output chars. Add padding consideration.
    let output_len = ((input_bytes.len() + 2) / 3) * 4;
    let mut encoded = String::with_capacity(output_len);
    let char_set_bytes = CHAR_SET.as_bytes(); // Work with bytes for efficient indexing

    // Process input in chunks of 3 bytes
    for chunk in input_bytes.chunks(3) {
        // Combine bytes into a 24-bit integer (u32)
        // byte1 << 16 | byte2 << 8 | byte3
        let mut combined: u32 = (chunk[0] as u32) << 16;
        if chunk.len() > 1 {
            combined |= (chunk[1] as u32) << 8;
        }
        if chunk.len() > 2 {
            combined |= chunk[2] as u32;
        }

        // Extract 4 6-bit indices from the 24-bit integer
        let idx1 = (combined >> 18) & 63;
        let idx2 = (combined >> 12) & 63;
        let idx3 = (combined >> 6) & 63;
        let idx4 = combined & 63;

        // Append corresponding Base64 characters
        encoded.push(char_set_bytes[idx1 as usize] as char);
        encoded.push(char_set_bytes[idx2 as usize] as char);

        // Handle padding for the last chunk
        if chunk.len() > 1 {
            encoded.push(char_set_bytes[idx3 as usize] as char);
        } else {
            encoded.push(PADDING_CHAR); // Pad 3rd char if only 1 input byte
        }

        if chunk.len() > 2 {
            encoded.push(char_set_bytes[idx4 as usize] as char);
        } else {
            encoded.push(PADDING_CHAR); // Pad 4th char if 1 or 2 input bytes
        }
    }

    encoded
}

fn main() -> Result<(), Box<dyn Error>> {
    let file_path = "favicon.ico"; // Hardcoded filename as in C++ example

    // --- File Reading ---
    // Open the file
    let path = Path::new(file_path);
    let mut file = File::open(&path)
        .map_err(|e| format!("Error opening file '{}': {}", file_path, e))?; // More context on error

    // Read the entire file into a vector of bytes
    let mut buffer = Vec::new();
    file.read_to_end(&mut buffer)
        .map_err(|e| format!("Error reading file '{}': {}", file_path, e))?;

    // --- Encoding ---
    let encoded_string = encode(&buffer);

    // --- Output ---
    // Write the encoded string bytes to standard output
    io::stdout().write_all(encoded_string.as_bytes())?;
    io::stdout().flush()?; // Ensure output is written immediately

    Ok(()) // Indicate success
}
