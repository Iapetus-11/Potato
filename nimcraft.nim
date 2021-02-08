import src/je/util/struct

var fmt: array[0..3, char] = ['b', 'B', 'q', 'i']
var data: array[0..3, int] = [1, 2, 100000, 6969]

var result: string = pack(fmt, data)

echo result
