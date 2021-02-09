import endians
import streams

const formatCodes: array[0..9, char] = ['b', 'B', 'h', 'H', 'i', 'I', 'q', 'Q', 'f', 'd']

type
  anyStructData* = int8 | uint8 | bool | int16 | uint16 | int32 | uint32 | int64 | uint64 | float

proc pack(b: int8, endian: char): int8 =  # endianness doesn't matter here since it's just one byte
  return b

proc pack(b: uint8, endian: char): uint8 = # endianness again doesn't matter here since it's just one byte
  return b

proc pack(b: bool, endian: char): bool = # big woop endianness doesn't matter bc bool is just one byte
  return b

proc pack(h: int16, endian: char): int16 =
  var h: int16 = h

  if endian == '>':
    bigEndian16(addr result, addr h)
  else:
    littleEndian16(addr result, addr h)

proc pack(h: uint16, endian: char): uint16 =
  var h: uint16 = h

  if endian == '>':
    bigEndian16(addr result, addr h)
  else:
    littleEndian16(addr result, addr h)

proc pack(i: int32, endian: char): int32 =
  var i: int32 = i

  if endian == '>':
    bigEndian32(addr result, addr i)
  else:
    littleEndian32(addr result, addr i)

proc pack(i: uint32, endian: char): uint32 =
  var i: uint32 = i

  if endian == '>':
    bigEndian32(addr result, addr i)
  else:
    littleEndian32(addr result, addr i)

proc pack(q: int64, endian: char): int64 =
  var q: int64 = q

  if endian == '>':
    bigEndian64(addr result, addr q)
  else:
    littleEndian64(addr result, addr q)

proc pack(q: uint64, endian: char): uint64 =
  var q: uint64 = q

  if endian == '>':
    bigEndian64(addr result, addr q)
  else:
    littleEndian64(addr result, addr q)

proc pack*(fmt: string, data: openArray[int]): string =
  if len(fmt) != len(data) + 1:
    raise newException(ValueError, "Data is invalid for format given.")

  let endianness: char = fmt[0]

  if endianness != '>' and endianness != '<':
    raise newException(ValueError, "Invalid endianness specified in format.")

  var s = newStringStream()

  for i in countup(0, len(data)-1):
    if fmt[i+1] == 'b':
      s.write(pack(int8(data[i]), endianness))
    elif fmt[i+1] == 'B':
      s.write(pack(uint8(data[i]), endianness))
    elif fmt[i+1] == 'h':
      s.write(pack(int16(data[i]), endianness))

  s.setPosition(0)
  return s.readAll()
