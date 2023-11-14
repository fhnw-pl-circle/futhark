-- compile: futhark c dotprod.fut
-- run: echo [2,2,3] [4,5,6] | ./dotprod

def main (x: []i32) (y: []i32): i32 =
  reduce (+) 0 (map2 (*) x y)
