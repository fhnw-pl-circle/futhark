# Futhark language overview


<small>https://futhark-book.readthedocs.io/en/latest/language.html</small>
<!-- generate with: futhark literate language.fut -->


Futhark:
- purely functional
- data-parallel
- syntactically and conceptually like haskell / standard ML
- very simple (no type classes, monads etc..)
- but has everything needed to express parallel algorithms


## Hello world

```futhark
def dot (x: []i32) (y: []i32): i32 =
  reduce (+) 0 (map2 (*) x y)
```

the usage:


```
> dot [2,2,3] [4,5,6]
```

```
36i32
```


## Data types


- i8, i16, i32, i64
- u8, u16, u32, u64
- f32, f64
- bool


```
> (12, 12.1)
```

```
(12i32, 12.1f64)
```


```
> (12u8, -3i16, 0f32)
```

```
(12u8, -3i16, 0.0f32)
```

```futhark
def f64_to_i32 (x: f64): i32 = i32.f64 x

def add_square x y = -- everything implicit i32
    let sum = x + y
    let result = sum * sum
    in result
```

```
> add_square 1 3
```

```
16i32
```

```futhark
def add_tuple (t: (i64, i64)) = 
    let (x, y) = t
    in x + y

def abs x = if x < 0 then -x else x

def list: []i8 = [1, 2, 3]
def range: []i16 = 5...12
def range2: []i16 = 0..3..<10

def concat = range ++ range2
```

```
> concat
```

```
[5i16, 6i16, 7i16, 8i16, 9i16, 10i16, 11i16, 12i16, 0i16, 3i16, 6i16, 9i16]
```

```futhark
type Point = (i32, i32) -- only structural
```

## Array operations

```futhark
def ops = 
    let zipped = zip list [-1, 0, 1]
    let mapped = map (+2) list
    let mapped_ = map (\x -> x * 4) list
    let mapped2 = map2 (+) [1,2,3] [4,5,6]
    let summed = reduce (+) 0 mapped
    let scanned = scan (+) 0 [1,2,3]
    in scanned
```

```
> ops
```

```
[1i32, 3i32, 6i32]
```

```futhark
def filtered = filter (<3) [1,5,2,3,4]
```

## Size types
Most array-sizes are known (but may be anonymous)


these are equivalent:

```futhark
def dotprod1 (xs: []i32) (ys: []i32): i32 =
  reduce (+) 0 (map2 (*) xs ys)

def dotprod2 [n] (xs: [n]i32) (ys: [n]i32): i32 =
  reduce (+) 0 (map2 (*) xs ys)
```

`[n]` is a size parameter  
always has type i64 and can be used in body

```futhark
def average [n] (xs: [n]f64): f64 =
  reduce (+) 0 xs / f64.i64 n
```

```
> average [1,5,25]
```

```
10.333333333333334f64
```


normal i64 parameters can also be used in return type

```futhark
def replicate_i32 (n: i64) (x: i32): [n]i32 =
  map (\_ -> x) (0..<n)

def matmult [n][m][p] (x: [n][m]i32, y: [m][p]i32): [n][p]i32 =
  map (\xr -> map (dotprod1 xr) (transpose y)) x
```

but cant be dynamic  
cant be: `def dup [n] (xs: [n]i32): [2*n]i32 =`

```futhark
def dup [n] (xs: [n]i32): []i32 = -- anonymous size
  map (\i -> xs[i/2]) (0..<n*2)
```

we have to cast using `:>` to use it where array size is relevant  
uses a runtime check

```futhark
def zipped = zip (dup [1,2,3] :> [6]i32) (dup [3,2,1] :> [6]i32)
```

## Records

```futhark
type complex = {re: f64, im: f64}

def sqrt_minus_one = {im = -1.0, re = 0.0}
```

are just structural

```futhark
def sqrt_minus_one_: {re: f64, im: f64} = {re = 0.0, im = -1.0}

def conj (c: complex): complex =
  {re = c.re, im = -c.im}

def conj_ ({re, im}: complex): complex =
  {re, im = -im}
```

tuples are also records (with numeric keys)

```futhark
def tuple_rec: {0:i32,1:f64} = (12, 3.4)
```

## Parametric polymorphism

```futhark
def replicate 't (n: i64) (x: t): [n]t =
  map (\_ -> x) (0..<n)
```

as we dont have type classes, the usefullness is limited (cant perform calculations on parameters)


## Higher order functions


are "inlined" during compilation -> certain restrictions:


- Functions may not be stored inside arrays.
- Functions may not be returned from branches in conditional expressions.
- Functions are not allowed in loop parameters.

```futhark
def pos_len = filter (>0) [1,-2,3] |> length
```

## Sequential loops


futhark doesnt support recursion, but recursive algorithms can be expressed using sequential loops

```futhark
def fib(n: i32): i32 =
  let (x, _) = loop (x, y) = (1,1) for i < n do (y, x+y)
  in x
```

## in-place updates


certain algorithms can be better expressed using an imperative style

```futhark
def fib2 (n: i64): [n]i32 =
  -- Create "empty" array.
  let arr = replicate n 1
  -- Fill array with Fibonacci numbers.
  in loop (arr) for i < n-2 do
       arr with [i+2] = arr[i] + arr[i+1]
```

or:

```futhark
def fib3 (n: i64): [n]i32 =
  -- Create "empty" array.
  let arr = replicate n 1
  -- Fill array with Fibonacci numbers.
  in loop (arr) for i < n-2 do
       let arr[i+2] = arr[i] + arr[i+1]
       in arr
```

Futhark doesnt copy, it updates in-place and ensures uniqueness!

```futhark
def modify (a: *[]i32) (i: i64) (x: i32): *[]i32 =
  a with [i] = a[i] + x
```

The `*[]t` param means, that there cant be any other reference to this data (the function has *ownership*)


Same for the return type: the parant scope has ownership (no other references exist)


`let b = modify a i x` is only valid, if `a` isnt used anymore afterwards


"Consuming a value": passing the value as a unique type to a function, or using it in a in-place expression


we can only return values as a unique type, when it doesnt share any values with any non-unique params

