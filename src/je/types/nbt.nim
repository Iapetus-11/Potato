import streams

import ../../struct

type
  TAG = ref object of RootObj
    id: int
    name: string

  TAG_End = ref object of TAG
    data: void

  TAG_Byte = ref object of TAG
    data: int8

  TAG_Short = ref object of TAG
    data: int16

  TAG_Int = ref object of TAG
    data: int32

  TAG_Long = ref object of TAG
    data: int64

  TAG_Float = ref object of TAG
    data: float32

  TAG_Double = ref object of TAG
    data: float64

  TAG_Byte_Array = ref object of TAG
    data: openArray[int8]

  TAG_String = ref object of TAG
    data: string

  TAG_List = ref object of TAG
    data: seq

  TAG_Compound = ref object of TAG
    data: seq[ptr]

  TAG_Int_Array = ref object of TAG
    data: seq[int32]

  TAG_Long_Array = ref object of TAG
    data: seq[int64]

proc packID(s: Stream, t: TAG) =
  s.pack(t.id)

proc unpackID(s: Stream): int8 =
  return s.unpackByte()
