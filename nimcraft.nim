import src/je/util/struct

var data: array[0..3, int] = [1, 2, 100000, 6969]

var result: string = pack("bBqi", data)

echo result
