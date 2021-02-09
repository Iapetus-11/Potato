import streams

import src/struct

var s: Stream = newStringStream()

struct.pack(s, '>', 'B', 123)
struct.pack(s, '<', 'i', 69)
struct.pack(s, '>', 'f', 12.1)
struct.pack(s, '>', 'q', 100000000)

echo s.getPosition()

echo struct.unpackUByte(s)
echo struct.unpackInt(s, '<')
echo struct.unpackFloat(s)
echo struct.unpackLong(s)
