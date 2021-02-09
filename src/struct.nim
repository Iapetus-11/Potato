import endians
import streams

# const
#   formatCodes: array[0..9, char] = ['b', 'B', 'h', 'H', 'i', 'I', 'q', 'Q', 'f', 'd']

type
  structData* = bool | int8 | uint8 | int16 | uint16 | int32 | uint32 | int64 | uint64 | float32 | float64

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

proc pack*(s: Stream, endianness: char = '>', fmt: char, data: structData, ignorePos: bool = true) {.discardable.} =
  if endianness != '>' and endianness != '<':
    raise newException(ValueError, "Invalid endianness: " & endianness)

  if ignorePos:
    let originalPos: int = s.getPosition()
    s.setPosition(len(s.readAll()))

    defer: s.setPosition(originalPos)

  if fmt == 'b':
    s.write(int8(data))
  elif fmt == 'B':
    s.write(uint8(data))
  elif fmt == '?':
    s.write(bool(data))
  elif fmt == 'h':
    s.write(endianize(int16(data), endianness))
  elif fmt == 'H':
    s.write(endianize(uint16(data), endianness))
  elif fmt == 'i':
    s.write(endianize(int32(data), endianness))
  elif fmt == 'I':
    s.write(endianize(uint32(data), endianness))
  elif fmt == 'q':
    s.write(endianize(int64(data), endianness))
  elif fmt == 'Q':
    s.write(endianize(uint64(data), endianness))
  elif fmt == 'f':
    s.write((float32(data)))
  elif fmt == 'd':
    s.write((float64(data)))

  raise newException(ValueError, "Invalid format: " & fmt)

proc unpackInt8*(s: Stream, endianness: char = '>'): int8 =
  return s.readInt8()

proc unpackUint8*(s: Stream, endianness: char = '>'): uint8 =
  return s.readUint8()

proc unpackInt16*(s: Stream, endianness: char = '>'): int16 =
  return endianize(s.readInt16(), endianness)

proc unpackUint16*(s: Stream, endianness: char = '>'): uint16 =
  return endianize(s.readUint16(), endianness)

proc unpackInt32*(s: Stream, endianness: char = '>'): int32 =
  return endianize(s.readInt32(), endianness)

proc unpackUint32*(s: Stream, endianness: char = '>'): uint32 =
  return endianize(s.readUint32(), endianness)

proc unpackInt64*(s: Stream, endianness: char = '>'): int64 =
  return endianize(s.readInt64(), endianness)

proc unpackUint64*(s: Stream, endianness: char = '>'): uint64 =
  return endianize(s.readUint64(), endianness)

proc unpackFloat32*(s: Stream, endianness: char = '>'): float32 =
  return s.readFloat32()

proc unpackFloat64*(s: Stream, endianness: char = '>'): float64 =
  return s.readFloat64()
