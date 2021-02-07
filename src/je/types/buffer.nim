
type
  Buffer* = ref object of RootObj
    buf: seq[byte]
    pos: int32
