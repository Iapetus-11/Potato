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

proc pack*(s: Stream, fmt: string, data: structData) {.discardable.} =
  let endianness: char = fmt[0]

  if endianness != '>' and endianness != '<':
    raise newException(ValueError, "Invalid endianness specified in format.")

  let originalPos: int = s.getPosition()
  s.setPosition(len(s.readAll()))

  if fmt[1] == 'b':
    s.write(int8(data))
  elif fmt[1] == 'B':
    s.write(uint8(data))
  elif fmt[1] == '?':
    s.write(bool(data))
  elif fmt[1] == 'h':
    s.write(endianize(int16(data), endianness))
  elif fmt[1] == 'H':
    s.write(endianize(uint16(data), endianness))
  elif fmt[1] == 'i':
    s.write(endianize(int32(data), endianness))
  elif fmt[1] == 'I':
    s.write(endianize(uint32(data), endianness))
  elif fmt[1] == 'q':
    s.write(endianize(int64(data), endianness))
  elif fmt[1] == 'Q':
    s.write(endianize(uint64(data), endianness))
  elif fmt[1] == 'f':
    s.write((float32(data)))
  elif fmt[1] == 'd':
    s.write((float64(data)))
  else:
    raise newException(ValueError, "Invalid format: " & fmt[1])

  s.setPosition(originalPos)