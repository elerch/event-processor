const std = @import("std");
const fmt = std.fmt;
const json = std.json;
const Address = std.net.Address;
usingnamespace @import("routez");
const allocator = std.heap.page_allocator;

// zig compiler error spawning processes with >0.6.0 evented IO
//pub const io_mode = .evented;

pub const RequestResponse = struct {
    method: []const u8,
    headers: Headers,
    path: []const u8,
    query: []const u8,
    body: []const u8,
};

pub fn main() !void {
    var server = Server.init(
        allocator,
        .{},
        .{
            all("*", allHandler),
        },
    );
    var addr = try Address.parseIp("0.0.0.0", 9090);
    try server.listen(addr);
}

fn allHandler(req: Request, res: Response) !void {
    const Header = struct {
        name: []const u8,
        value: []const u8,
    };
    const Res_response = struct {
        method: []const u8,
        headers: []Header,
        path: []const u8,
        query: []const u8,
        body: []const u8,
        //version: Version,
    };
    var res_headers = try allocator.alloc(Header, req.headers.list.items.len);
    defer allocator.free(res_headers);
    for (req.headers.list.items) |h, i| {
        res_headers[i] = Header{ .name = h.name, .value = h.value };
    }

    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();
    try json.stringify(Res_response{
        .method = req.method,
        .headers = res_headers,
        .path = req.path,
        .query = req.query,
        .body = req.body,
    }, json.StringifyOptions{}, arr.writer());

    _ = async launchProcess(arr.items);

    res.status_code = StatusCode.Accepted;
    try res.body.writeAll("Accepted\n");
}

fn launchProcess(items: []const u8) !void {
    const process = try std.ChildProcess.init(&[_][]const u8{ "event-processor-backend", items }, allocator);
    defer process.deinit();
    _ = try process.spawnAndWait();
}
