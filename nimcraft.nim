import src/je/util/struct

var data: array[0..3, int] = [1, 2, 100000, 6969]

var result: string = struct.pack(">i?if", data)

echo repr(result)
