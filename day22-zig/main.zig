const std = @import("std");

const Pos = struct {
    row: i32,
    col: i32,
};

const Dir = enum { up, right, down, left };
const NodeState = enum { weakened, infected, flagged };

const Carrier = struct {
    pos: Pos,
    dir: Dir,

    pub fn rotate_right(self: *Carrier) void {
        switch (self.dir) {
            .up => self.dir = Dir.right,
            .right => self.dir = Dir.down,
            .down => self.dir = Dir.left,
            .left => self.dir = Dir.up,
        }
    }

    pub fn rotate_left(self: *Carrier) void {
        switch (self.dir) {
            .up => self.dir = Dir.left,
            .right => self.dir = Dir.up,
            .down => self.dir = Dir.right,
            .left => self.dir = Dir.down,
        }
    }

    pub fn step(self: *Carrier) void {
        switch (self.dir) {
            .up => self.pos.row -= 1,
            .right => self.pos.col += 1,
            .down => self.pos.row += 1,
            .left => self.pos.col -= 1,
        }
    }
};

pub fn step(carrier: *Carrier, map: *std.AutoHashMap(Pos, NodeState), infections: *usize) !void {
    if (map.getPtr(carrier.pos)) |state| {
        switch (state.*) {
            .weakened => {
                state.* = .infected;
                infections.* += 1;
            },
            .infected => {
                carrier.rotate_right();
                state.* = .flagged;
            },
            .flagged => {
                carrier.rotate_right();
                carrier.rotate_right();
                _ = map.remove(carrier.pos);
            },
        }
    } else {
        try map.put(carrier.pos, .weakened);
        carrier.rotate_left();
    }

    carrier.step();
}

pub fn main() !void {
    const gpa = std.heap.page_allocator;

    var map = std.AutoHashMap(Pos, NodeState).init(gpa);
    defer map.deinit();

    var stdin = std.io.getStdIn().reader();
    var buf: [256]u8 = undefined;

    var row: i32 = 0;
    while (true) {
        const maybe_slice = try stdin.readUntilDelimiterOrEof(buf[0..], '\n');

        if (maybe_slice) |slice| {
            for (slice, 0..) |char, col| {
                if (char == '#') {
                    try map.put(.{ .row = row, .col = @intCast(col) }, NodeState.infected);
                }
            }
        } else break;
        row += 1;
    }

    var carrier: Carrier = .{ .pos = .{ .row = @divTrunc(row, 2), .col = @divTrunc(row, 2) }, .dir = Dir.up };

    var infections: usize = 0;
    for (0..10000000) |_| {
        try step(&carrier, &map, &infections);
    }

    try std.io.getStdOut().writer().print("{}\n", .{infections});
}
