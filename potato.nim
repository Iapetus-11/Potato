import streams

import src/je/nbt
import src/je/structext
import src/struct
import src/mutf8

var fs: FileStream = newFileStream("bigtest.nbt")

let t: TAG = nbt.unpack(fs)

# Test MUTF8 utils
# let myString: string = "Hello WorldȀȀ∃𠀋"
# echo mutf8.encodeMUTF8(myString)
# echo mutf8.decodeMUTF8(mutf8.encodeMUTF8(myString))

# var s: Stream = newStringStream()
#
# struct.packUByte(s, 123)
# struct.packInt(s, 123, '<')
# struct.packFloat(s, 12.1)
# struct.packLong(s, 120000000)
#
# s.setPosition(0)
#
# echo struct.unpackUByte(s)
# echo struct.unpackInt(s, '<')
# echo struct.unpackFloat(s)
# echo struct.unpackLong(s)
