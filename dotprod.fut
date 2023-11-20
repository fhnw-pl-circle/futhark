-- compile: futhark c dotprod.fut
-- run: echo [2,2,3] [4,5,6] | ./dotprod

-- benchmark with: futhark bench dotprod.fut --backend=opencl
-- ==
-- compiled random input { [10000]i32 [10000]i32 } auto output
-- compiled random input { [100000]i32 [100000]i32 } auto output
-- compiled random input { [1000000]i32 [1000000]i32 } auto output
-- compiled random input { [10000000]i32 [10000000]i32 } auto output

def main (x: []i32) (y: []i32): i32 =
  reduce (+) 0 (map2 (*) x y)
