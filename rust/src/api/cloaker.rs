#[flutter_rust_bridge::frb(sync)]
pub fn cloak(bytes: &[u8], message: &[u8]) -> Option<Vec<u8>> {
    // Implement the cloak functionality here
    Some(vec![])
}

#[flutter_rust_bridge::frb(sync)]
pub fn uncloak(bytes: &[u8]) -> Vec<u8> {
    // Implement the uncloak functionality here
    vec![]
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
