import streams

import src/je/util/stream

var s: StringStream = newStringStream()

echo repr(s.peekStr(100))

s.pack_byte(123)

echo repr(s.peekStr(100))
