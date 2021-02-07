import streams

import src/je/types/stream_utils

var s: StringStream = newStringStream()

echo repr(s)

s.pack_varint(123)

echo repr(s)
