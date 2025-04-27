const std = @import("std");
const rl = @import("raylib");

const Board = @import("board.zig").Board;
const Tile = @import("tile.zig").Tile;
const TileKind = @import("tile.zig").TileKind;

/// The size (width and height) of each tile in pixels.
pub const TILE_SIZE: i32 = 10;
/// The width of the board in tiles.
pub const BOARD_WIDTH: usize = 80;
/// The height of the board in tiles.
pub const BOARD_HEIGHT: usize = 60;

/// Manages the overall game state and logic.
pub const Game = struct {
    /// The game board.
    board: Board,

    /// Creates a new game instance.
    pub fn new() Game {
        return Game{
            .board = Board.new(),
        };
    }

    /// Updates the game state for one frame.
    /// Primarily handles the falling sand simulation.
    pub fn update(self: *Game) void {
        var y: usize = BOARD_HEIGHT - 2;
        while (true) {
            for (0..BOARD_WIDTH) |x| {
                if (self.board.tiles[y][x].kind == TileKind.sand) {
                    self.tryMoveSand(x, y);
                }
            }

            if (y == 0) {
                break;
            }

            y -= 1;
        }
    }

    /// Attempts to move a sand particle located at (x, y).
    /// Checks downwards, then down-left, then down-right.
    fn tryMoveSand(self: *Game, x: usize, y: usize) void {
        const below_y = y + 1;
        if (self.board.isWithinBounds(x, below_y)) {
            if (self.board.isEmpty(x, below_y)) {
                self.board.moveTile(x, y, x, below_y);
                return;
            }

            var left_free: bool = false;
            var right_free: bool = false;

            if (x > 0) {
                const diag_left_x = x - 1;
                left_free = self.board.isEmpty(diag_left_x, below_y);
            }

            if (x + 1 < BOARD_WIDTH) {
                const diag_right_x = x + 1;
                right_free = self.board.isEmpty(diag_right_x, below_y);
            }

            if (left_free and right_free) {
                const time_int: u64 = @intFromFloat(rl.getTime() * 100.0);
                if (@mod(time_int, 2) == 0) {
                    self.board.moveTile(x, y, x - 1, below_y);
                } else {
                    self.board.moveTile(x, y, x + 1, below_y);
                }
            } else if (left_free) {
                self.board.moveTile(x, y, x - 1, below_y);
            } else if (right_free) {
                self.board.moveTile(x, y, x + 1, below_y);
            }
        }
    }

    /// Adds a sand particle at the specified pixel coordinates if the corresponding tile is empty.
    /// Calculates the tile coordinates from pixel coordinates.
    pub fn addSandAtPixel(self: *Game, pixelX: i32, pixelY: i32) void {
        const tileX = @divFloor(pixelX, TILE_SIZE);
        const tileY = @divFloor(pixelY, TILE_SIZE);

        if (tileX >= 0 and @as(usize, @intCast(tileX)) < BOARD_WIDTH and tileY >= 0 and @as(usize, @intCast(tileY)) < BOARD_HEIGHT) {
            const ux: usize = @intCast(tileX);
            const uy: usize = @intCast(tileY);

            if (self.board.isEmpty(ux, uy)) {
                const time = rl.getTime();
                const current_hue = @mod(time * 30.0, 360.0);
                self.board.tiles[uy][ux] = Tile{
                    .kind = TileKind.sand,
                    .hue = @floatCast(current_hue),
                };
            }
        }
    }

    /// Renders the current state of the game board to the screen.
    pub fn render(self: *const Game) void {
        for (self.board.tiles, 0..) |row, y| {
            for (row, 0..) |tile, x| {
                if (tile.kind == TileKind.sand) {
                    const pixelX = @as(i32, @intCast(x)) * TILE_SIZE;
                    const pixelY = @as(i32, @intCast(y)) * TILE_SIZE;
                    rl.drawRectangle(pixelX, pixelY, TILE_SIZE, TILE_SIZE, rl.colorFromHSV(tile.hue, 1.0, 1.0));
                }
            }
        }
    }
};
