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

proc pack*(s: Stream, endianness: char, fmt: char, data: structData, ignorePos: bool = true) {.discardable.} =
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

proc unpack*(s: Stream, endianness: char, fmt: char, to: ptr) {.discardable.} =
  if endianness != '>' and endianness != '<':
    raise newException(ValueError, "Invalid endianness: " & endianness)

  if fmt == 'b':
    to[] = int8(s.readInt8())
  elif fmt == 'B':
    to[] = uint8(s.readUint8())
  elif fmt == '?':
    to[] = bool(s.readInt8())
  elif fmt == 'h':
    to[] = endianize(int16(s.readInt16()), endianness)
  elif fmt == 'H':
    to[] = endianize(uint16(s.readUint16()), endianness)
  elif fmt == 'i':
    to[] = endianize(int32(s.readInt32()), endianness)
  elif fmt == 'I':
    to[] = endianize(uint32(s.readUint32()), endianness)
  elif fmt == 'q':
    to[] = endianize(int64(s.readInt64()), endianness)
  elif fmt == 'Q':
    to[] = endianize(uint64(s.readUint64()), endianness)
  elif fmt == 'f':
    to[] = float32(s.readFloat32())
  elif fmt == 'd':
    to[] = float64(s.readFloat64())

  raise newException(ValueError, "Invalid format: " & fmt)
