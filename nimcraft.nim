import streams

import src/je/structext
import src/struct

var s: Stream = newStringStream()

struct.packUByte(s, 123)
struct.packInt(s, 123, '<')
struct.packFloat(s, 12.1)
struct.packLong(s, 120000000)

echo s.getPosition()

echo struct.unpackUByte(s)
echo struct.unpackInt(s, '<')
echo struct.unpackFloat(s)
echo struct.unpackLong(s)
