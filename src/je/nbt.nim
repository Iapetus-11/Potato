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
    data: openArray[int8]

  TAG_String* = ref object of TAG
    data: string

  TAG_List* = ref object of TAG
    data: seq

  TAG_Compound* = ref object of TAG
    data: seq[ptr]

  TAG_Int_Array* = ref object of TAG
    data: seq[int32]

  TAG_Long_Array* = ref object of TAG
    data: seq[int64]

proc tagRef(id: int8): type =
  case id:
    of 0:
      return TAG_End
    of 1:
      return TAG_Byte
    of 2:
      return TAG_Short
    of 3:
      return TAG_Int
    of 4:
      return TAG_Long
    of 5:
      return TAG_Float
    of 6:
      return TAG_Double
    of 7:
      return TAG_Byte_Array
    of 8:
      return TAG_String
    of 9:
      return TAG_List
    of 10:
      return TAG_Compound
    of 11:
      return TAG_Int_Array
    of 12:
      return TAG_Long_Array
    else:
      raise newException(ValueError, "Invalid id: " & $id)


proc packID(s: Stream, t: TAG) =
  struct.packByte(s, t.id)

proc unpackID(s: Stream): int8 =
  return struct.unpackByte(s)

proc packName(s: Stream, name: string) =
  let name: string = mutf8.encodeMUTF8(name)

  struct.packUShort(s, uint16(len(name)))
  s.write(name)

proc unpackName(s: Stream): string =
  return mutf8.decodeMUTF8(s.readStr(int(struct.unpackUShort(s))))

proc pack(s: Stream, t: TAG) =
  packID(s, t)
  # packName(s, t)
  # packContent(s, t)

proc unpack(s: Stream): TAG =
  let id: int8 = unpackID(s)

  case id:
    of 0:
      return TAG_End(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 1:
      return TAG_Byte(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 2:
      return TAG_Short(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 3:
      return TAG_Int(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 4:
      return TAG_Long(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 5:
      return TAG_Float(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 6:
      return TAG_Double(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 7:
      return TAG_Byte_Array(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 8:
      return TAG_String(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 9:
      return TAG_List(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 10:
      return TAG_Compound(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 11:
      return TAG_Int_Array(id: id, name: unpackName(s), data: unpackContent(s, id))
    of 12:
      return TAG_Long_Array(id: id, name: unpackName(s), data: unpackContent(s, id))
    else:
      raise newException(ValueError, "Invalid id: " & $id)
