import streams

import src/struct

var s: Stream = newStringStream()

struct.pack(s, '>', 'B', 123)
struct.pack(s, '<', 'i', 69)
struct.pack(s, '>', 'f', 12.1)
struct.pack(s, '>', 'q', 100000000)

echo repr(s.readAll())
