-- compined version
-- 
-- entry matmul [n][m][p] (x: [n][m]i32) (y: [m][p]i32): [n][p]i32 =
--   map (\xr -> map (\yc -> reduce (+) 0 (map2 (*) xr yc))
--                   (transpose y))
--       x


-- benchmark with: futhark bench matmul.fut --backend=opencl
-- ==
-- entry: matmul
-- compiled random input { [1024][512]i32 [512][1024]i32 } auto output
-- compiled random input { [2000][2000]i32 [2000][2000]i32 } auto output

def dotprod (xs: []i32) (ys: []i32): i32 =
  reduce (+) 0 (map2 (*) xs ys)

entry matmul [n][m][p] (x: [n][m]i32) (y: [m][p]i32): [n][p]i32 =
  map (\xr -> map (dotprod xr) (transpose y)) x