import streams

import src/je/types/stream_utils

var s: StringStream = newStringStream()

echo repr(s.peekStr(100))

s.pack_byte(123)

echo repr(s.peekStr(100))
