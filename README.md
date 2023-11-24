# Futhark

## Environment setup

[Offical installation instructions](https://futhark.readthedocs.io/en/stable/installation.html)

This devcontainer will run on any system that is set up to run other devcontainers with docker (but make sure to start it up once, as creating the image takes some time...).

But using the default setup wont be able to access the GPU and none of futharks performance.

To be able to access your (NVIDIA or AMD) GPU with a Linux host, follow a guide such as [this one](https://linuxhandbook.com/setup-opencl-linux-docker/) and comment out the line `,"runArgs": ["--gpus", "all"]` in the .devcontainer.json and the last `RUN` instruction in the Dockerfile (they are for a standard NVIDIA setup and have to be adapted for AMD GPUs).

## Hello World

Once in the devontainer (or having futhark installed any other way), make sure you are in the repository root (containing the file `dotprod.fut`), or create one with the following contents somewhere else:

```futhark
def main (x: []i32) (y: []i32): i32 =
  reduce (+) 0 (map2 (*) x y)
```

Compile and run it:

```bash
futhark c dotprod.fut
echo [2,2,3] [4,5,6] | ./dotprod
```

This should output `36i32`.


You can also play with futhark in its REPL (running `futhark repl`):

```
$ futhark repl
┃╱╱ ┃╲    ┃   ┃╲  ┃╲   ╱
┃╱  ┃ ╲   ┃╲  ┃╲  ┃╱  ╱ 
┃   ┃  ╲  ┃╱  ┃   ┃╲  ╲ 
┃   ┃   ╲ ┃   ┃   ┃ ╲  ╲
Version 0.26.0.
Copyright (C) DIKU, University of Copenhagen, released under the ISC license.

Run :help for a list of commands.
[0]> 1 + 1
2
[1]> :load dotprod.fut 
Loading dotprod.fut
[0]> main [2,2,3] [4,5,6]
36
[1]> 
```

## Contents

1. Language overview: [language.fut](./language.fut) & [language.md](./language.md)
2. Testing [testing.fut](./testing.fut)
3. Benchmarking [dotprod.fut](./dotprod.fut)
4. Usage & integrating with other languages [raytrace.fut](./raytrace.fut) & [raytrace_nb.ipynb](./raytrace_nb.ipynb)
5. Comparison with classical approach [matmul.fut](./matmul.fut) & [matmul_nb.ipynb](./matmul_nb.ipynb)

## Resources

[Homepage](https://futhark-lang.org/)

[Futhark Book](https://futhark-book.readthedocs.io/en/latest/)

[Futhark Examples](https://futhark-lang.org/examples.html)

[Futhark Benchmark](https://futhark-lang.org/performance.html)