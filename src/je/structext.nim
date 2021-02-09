import streams

import ../struct

proc packVarint(num: int, max_bits: int = 32): string =
  let numMin =
