import streams

import ../struct
import ../mutf8

type
  TAG* = ref object of RootObj
    id: int8
    name: string

  TAG_End* = ref object of TAG
    data: void

  TAG_Byte* = ref object of TAG
    data: int8

  TAG_Short* = ref object of TAG
    data: int16

  TAG_Int* = ref object of TAG
    data: int32

  TAG_Long* = ref object of TAG
    data: int64

  TAG_Float* = ref object of TAG
    data: float32

  TAG_Double* = ref object of TAG
    data: float64

  TAG_Byte_Array* = ref object of TAG
    data: seq[int8]

  TAG_String* = ref object of TAG
    data: string

  TAG_List* = ref object of TAG
    data: seq

  TAG_Compound* = ref object of TAG
    data: seq[TAG]

  TAG_Int_Array* = ref object of TAG
    data: seq[int32]

  TAG_Long_Array* = ref object of TAG
    data: seq[int64]

  # TagIDs = enum
  #   tag_end = 0,
  #   tag_byte = 1,
  #   tag_short = 2,
  #   tag_int = 3,
  #   tag_long = 4,
  #   tag_float = 5,
  #   tag_double = 6,
  #   tag_byte_array = 7,
  #   tag_string = 8,
  #   tag_list = 9,
  #   tag_compound = 10,
  #   tag_int_array = 11,
  #   tag_long_array = 12

proc packID(s: Stream, t: TAG) =
  struct.packByte(s, t.id)

proc unpackID(s: Stream): int8 =
  return struct.unpackByte(s)

proc packName(s: Stream, t: TAG) =
  let name: string = mutf8.encodeMUTF8(t.name)

  struct.packUShort(s, uint16(len(name)))
  s.write(name)

proc unpackName(s: Stream): string =
  return mutf8.decodeMUTF8(s.readStr(int(struct.unpackUShort(s))))

proc pack(s: Stream, t: TAG) =
  packID(s, t)
  # packName(s, t)
  packName(s, t)
  # packContent(s, t)

proc unpack(s: Stream, id: int8, name: string): TAG =
  case id:
    of 0:
      return TAG_End(id: id, name: name)
    of 1:
      return TAG_Byte(id: id, name: name, data: struct.unpackByte(s))
    of 2:
      return TAG_Short(id: id, name: name, data: struct.unpackShort(s))
    of 3:
      return TAG_Int(id: id, name: name, data: struct.unpackInt(s))
    of 4:
      return TAG_Long(id: id, name: name, data: struct.unpackLong(s))
    of 5:
      return TAG_Float(id: id, name: name, data: struct.unpackFloat(s))
    of 6:
      return TAG_Double(id: id, name: name, data: struct.unpackDouble(s))
    of 7:
      let name: string = unpackName(s)
      let length: int32 = struct.unpackInt(s)
      var byteArray: seq[int8]

      for _ in countup(0, length):
        byteArray.add(struct.unpackByte(s))

      return TAG_Byte_Array(id: id, name: name, data: byteArray)
    of 8:
      return TAG_String(id: id, name: unpackName(s), data: mutf8.decodeMUTF8(s.readStr(int(struct.unpackUShort(s)))))
    of 9:
      let name: string = unpackName(s)
      let typeID: int8 = struct.unpackByte(s)
      let length: int32 = struct.unpackInt(s)
      var tags: seq[TAG] = @[]

      for _ in countup(0, length):
        tags.add(unpack(s, typeID, ""))

      return TAG_List(id: id, name: name, data: tags)
    of 10:
      let name: string = unpackName(s)
      var tags: seq[TAG] = @[]

      while tags[^1].id != 0:
        tags.add(unpack(s, unpackID(s), unpackName(s)))

      return TAG_Compound(id: id, name: name, data: tags)
    of 11:
      let name: string = unpackName(s)
      let length: int32 = struct.unpackInt(s)
      var intArray: seq[int32]

      for _ in countup(0, length):
        intArray.add(struct.unpackInt(s))

      return TAG_Int_Array(id: id, name: name, data: intArray)
    of 12:
      let name: string = unpackName(s)
      let length: int32 = struct.unpackInt(s)
      var longArray: seq[int64]

      for _ in countup(0, length):
        longArray.add(struct.unpackLong(s))

      return TAG_Long_Array(id: id, name: name, data: longArray)
    else:
      raise newException(ValueError, "Invalid id: " & $id)

proc unpack(s: Stream): TAG =
    return unpack(s, unpackID(s), unpackName(s))
