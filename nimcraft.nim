import src/je/util/struct

var data: array[0..6, int] = [1, 2, 100000, 6969, 69, 420, 7]

var result: string = struct.pack(">i?iIbBf", data)

echo repr(result)
