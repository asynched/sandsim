const rl = @import("raylib");
const std = @import("std");
const Game = @import("game.zig").Game;

pub fn main() void {
    const screenWidth = 800;
    const screenHeight = 600;

    rl.initWindow(screenWidth, screenHeight, "Sand simulation");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var game = Game.new();

    while (!rl.windowShouldClose()) {
        if (rl.isMouseButtonDown(.left)) {
            game.addSandAtPixel(rl.getMouseX(), rl.getMouseY());
        }

        game.update();

        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);
        game.render();
    }
}
