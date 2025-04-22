use godot::prelude::*;
use godot::classes::Sprite2D;

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}

#[derive(GodotClass)]
#[class(base=Sprite2D, init)]
pub struct Player {
    speed: f64,
    angular_speed: f64,

    base: Base<Sprite2D>
}

