import streams

import src/struct

var s: Stream = newStringStream()

struct.pack(s, ">?", true)
struct.pack(s, ">q", 123)
struct.pack(s, ">f", 12.1)
struct.pack(s, ">b", 69)
struct.pack(s, "<q", 123)
struct.pack(s, ">b", 69)

echo repr(s.readAll())
