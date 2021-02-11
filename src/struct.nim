import endians
import streams

proc endianize(h: int16, endian: char): int16 =
  var h: int16 = h

  if endian == '>':
    bigEndian16(addr result, addr h)
  else:
    littleEndian16(addr result, addr h)

proc endianize(h: uint16, endian: char): uint16 =
  var h: uint16 = h

  if endian == '>':
    bigEndian16(addr result, addr h)
  else:
    littleEndian16(addr result, addr h)

proc endianize(i: int32, endian: char): int32 =
  var i: int32 = i

  if endian == '>':
    bigEndian32(addr result, addr i)
  else:
    littleEndian32(addr result, addr i)

proc endianize(i: uint32, endian: char): uint32 =
  var i: uint32 = i

  if endian == '>':
    bigEndian32(addr result, addr i)
  else:
    littleEndian32(addr result, addr i)

proc endianize(q: int64, endian: char): int64 =
  var q: int64 = q

  if endian == '>':
    bigEndian64(addr result, addr q)
  else:
    littleEndian64(addr result, addr q)

proc endianize(q: uint64, endian: char): uint64 =
  var q: uint64 = q

  if endian == '>':
    bigEndian64(addr result, addr q)
  else:
    littleEndian64(addr result, addr q)

proc packBool*(s: Stream, data: bool, endianness: char = '>') =
  s.write(data)

proc unpackBool*(s: Stream, endianness: char = '>'): bool =
  return bool(s.readInt8())

proc packByte*(s: Stream, data: int8, endianness: char = '>') =
  s.write(data)

proc unpackByte*(s: Stream, endianness: char = '>'): int8 =
  return s.readInt8()

proc packUByte*(s: Stream, data: uint8, endianness: char = '>') =
  s.write(data)

proc unpackUByte*(s: Stream, endianness: char = '>'): uint8 =
  return s.readUint8()

proc packShort*(s: Stream, data: int16, endianness: char = '>') =
  s.write(data)

proc unpackShort*(s: Stream, endianness: char = '>'): int16 =
  return endianize(s.readInt16(), endianness)

proc packUShort*(s: Stream, data: uint16, endianness: char = '>') =
  s.write(data)

proc unpackUShort*(s: Stream, endianness: char = '>'): uint16 =
  return endianize(s.readUint16(), endianness)

proc packInt*(s: Stream, data: int32, endianness: char = '>') =
  s.write(data)

proc unpackInt*(s: Stream, endianness: char = '>'): int32 =
  return endianize(s.readInt32(), endianness)

proc packUInt*(s: Stream, data: uint32, endianness: char = '>') =
  s.write(data)

proc unpackUInt*(s: Stream, endianness: char = '>'): uint32 =
  return endianize(s.readUint32(), endianness)

proc packLong*(s: Stream, data: int64, endianness: char = '>') =
  s.write(data)

proc unpackLong*(s: Stream, endianness: char = '>'): int64 =
  return endianize(s.readInt64(), endianness)

proc packULong*(s: Stream, data: uint64, endianness: char = '>') =
  s.write(data)

proc unpackULong*(s: Stream, endianness: char = '>'): uint64 =
  return endianize(s.readUint64(), endianness)

proc packFloat*(s: Stream, data: float32, endianness: char = '>') =
  s.write(data)

proc unpackFloat*(s: Stream, endianness: char = '>'): float32 =
  return s.readFloat32()

proc packDouble*(s: Stream, data: float64, endianness: char = '>') =
  s.write(data)

proc unpackDouble*(s: Stream, endianness: char = '>'): float64 =
  return s.readFloat64()
