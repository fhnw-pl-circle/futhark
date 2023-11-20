-- Example for futhark testing
-- ==
-- entry: replicate
-- input { 42i64 5i64 }
-- output { [42i64, 42i64, 42i64, 42i64, 42i64] }

-- run with: futhark test testing.fut

entry replicate (x: i64) (n: i64) =
    map (\_ -> x) (0...n)