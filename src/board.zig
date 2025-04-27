const Tile = @import("tile.zig").Tile;
const TileKind = @import("tile.zig").TileKind;

// Forward declare constants from game.zig (or a config file if preferred)
const BOARD_WIDTH: usize = @import("game.zig").BOARD_WIDTH;
const BOARD_HEIGHT: usize = @import("game.zig").BOARD_HEIGHT;

/// Represents the game board containing all tiles.
pub const Board = struct {
    /// 2D array holding the state of each tile.
    tiles: [BOARD_HEIGHT][BOARD_WIDTH]Tile,

    /// Creates a new board with all tiles initialized to empty.
    pub fn new() Board {
        return Board{
            .tiles = [_][BOARD_WIDTH]Tile{([_]Tile{Tile.empty} ** BOARD_WIDTH)} ** BOARD_HEIGHT,
        };
    }

    /// Checks if a given coordinate (x, y) is within the board boundaries.
    pub fn isWithinBounds(_: *const Board, x: usize, y: usize) bool {
        return x < BOARD_WIDTH and y < BOARD_HEIGHT;
    }

    /// Checks if the tile at the given coordinate (x, y) is empty.
    /// Assumes coordinates are already within bounds.
    pub fn isEmpty(self: *const Board, x: usize, y: usize) bool {
        return self.tiles[y][x].kind == TileKind.empty;
    }

    /// Moves a tile from (src_x, src_y) to (dest_x, dest_y).
    /// Sets the source tile to empty.
    /// Assumes coordinates are valid and the destination is empty.
    pub fn moveTile(self: *Board, src_x: usize, src_y: usize, dest_x: usize, dest_y: usize) void {
        self.tiles[dest_y][dest_x] = self.tiles[src_y][src_x];
        self.tiles[src_y][src_x] = Tile.empty;
    }
};
