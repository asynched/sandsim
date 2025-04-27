/// Represents the kind of tile.
pub const TileKind = enum(u1) {
    empty,
    sand,
};

/// Represents a single cell on the board.
pub const Tile = struct {
    /// Specifies whether the tile is empty or contains sand.
    kind: TileKind = .empty,
    /// Hue value for the color of the sand particle.
    hue: f32 = 0.0,

    /// Represents an empty tile constant.
    pub const empty = Tile{};
};
