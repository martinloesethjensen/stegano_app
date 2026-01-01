#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn answer_to_everything() -> i8 {
    42
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
