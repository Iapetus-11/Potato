import streams

import src/struct

var s: Stream = newStringStream()
var data: array[0..6, int] = [1, 2, 100000, 6969, 69, 420, 7]

struct.pack(s, ">i?iIbBf", data)

echo repr(s.readAll())
