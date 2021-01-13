#![no_std] // don't link the Rust standard library
#![no_main] // disable all Rust-level entry points

use core::panic::PanicInfo;

#[no_mangle] // don't mangle the name of this function
pub extern "C" fn _start() -> ! {
    // This function is the entry point, since the linker looks for a function name `_start` by
    // default.
    loop {}
}

/// This function is called on panic.
#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    loop {}
}
