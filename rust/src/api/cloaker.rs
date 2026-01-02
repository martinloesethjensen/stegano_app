use image::GenericImageView;

#[flutter_rust_bridge::frb(sync)]
pub fn cloak(image_bytes: &[u8], message: &str) -> Vec<u8> {
    let img = image::load_from_memory(image_bytes).expect("Invalid Image");
    let (width, height) = img.dimensions();
    let mut pixels = img.to_rgba8().into_raw();

    // Convert message to bits
    let mut bits = Vec::new();
    for byte in message.as_bytes() {
        for i in 0..8 {
            bits.push((byte >> i) & 1);
        }
    }
    // Add 8 zero bits as a null-terminator
    for _ in 0..8 {
        bits.push(0);
    }

    for (i, bit) in bits.iter().enumerate() {
        if i >= pixels.len() {
            break;
        }
        // Clear the last bit and set it to our message bit
        pixels[i] = (pixels[i] & 0xFE) | bit;
    }

    // Write the modified pixels to a PNG file in memory
    let mut buf = std::io::Cursor::new(Vec::new());
    let output_img = image::RgbaImage::from_raw(width, height, pixels).unwrap();
    image::DynamicImage::ImageRgba8(output_img)
        .write_to(&mut buf, image::ImageFormat::Png)
        .unwrap();
    buf.into_inner()
}

#[flutter_rust_bridge::frb(sync)]
pub fn uncloak(image_bytes: &[u8]) -> String {
    let img = image::load_from_memory(image_bytes).expect("Invalid Image");
    let pixels = img.as_bytes();
    let mut message_bytes = Vec::new();
    let mut current_byte = 0u8;
    let mut bit_count = 0;

    for &pixel_byte in pixels {
        let bit = pixel_byte & 1;
        current_byte |= bit << bit_count;
        bit_count += 1;

        if bit_count == 8 {
            // Null terminator
            if current_byte == 0 {
                break;
            }
            message_bytes.push(current_byte);
            current_byte = 0;
            bit_count = 0;
        }
    }

    String::from_utf8_lossy(&message_bytes).to_string()
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

#[cfg(test)]
mod tests {
    use super::*;
    use image::{ImageFormat, RgbaImage};
    use std::io::Cursor;

    // Helper function to create a valid PNG buffer in memory
    fn create_mock_png(width: u32, height: u32) -> Vec<u8> {
        let img = RgbaImage::new(width, height);
        let mut buf = Cursor::new(Vec::new());
        // We MUST encode as PNG so image::load_from_memory works in the functions
        img.write_to(&mut buf, ImageFormat::Png).unwrap();
        buf.into_inner()
    }

    #[test]
    fn test_cloak_uncloak_roundtrip() {
        let original_png = create_mock_png(20, 20);
        let secret_message = "Hello, this is some secret message!";

        // Cloak a PNG image with a secret message
        let cloaked_png = cloak(&original_png, secret_message);

        // Verify it still looks like a PNG (Check magic number)
        assert_eq!(&cloaked_png[0..4], &[0x89, 0x50, 0x4E, 0x47]);

        // Uncloak the PNG image to retrieve the secret message
        let recovered_message = uncloak(&cloaked_png);

        assert_eq!(secret_message, recovered_message);
    }

    #[test]
    fn test_empty_message() {
        let original_png = create_mock_png(10, 10);
        let secret_message = "";

        let cloaked_png = cloak(&original_png, secret_message);
        let recovered_message = uncloak(&cloaked_png);

        assert_eq!(recovered_message, "");
    }

    #[test]
    fn test_large_message_boundary() {
        let original_png = create_mock_png(5, 5); // Very small image
        let long_message = "This message is definitely too long for 25 pixels";

        let cloaked_png = cloak(&original_png, long_message);
        let recovered_message = uncloak(&cloaked_png);

        // The logic should handle the overflow gracefully (usually by truncating)
        assert!(long_message.contains(&recovered_message));
    }
}
