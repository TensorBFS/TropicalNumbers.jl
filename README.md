# TropicalNumbers

Tropical number algebra, still under development.

[![Build Status](https://travis-ci.com/GiggleLiu/TropicalNumbers.jl.svg?branch=master)](https://travis-ci.com/GiggleLiu/TropicalNumbers.jl)
[![Codecov](https://codecov.io/gh/GiggleLiu/TropicalNumbers.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/GiggleLiu/TropicalNumbers.jl)

## To start

```julia
pkg add git@github.com:GiggleLiu/TropicalNumbers.jl.git#master
```

## Why another tropical number?

Related packages includes

* [SimpleTropical.jl](https://github.com/scheinerman/SimpleTropical.jl)
* [TropicalSemiring.jl](https://github.com/saschatimme/TropicalSemiring.jl)

Tropical numbers in these packages contains an extra field `isinf`. Which is not nessesary because we have `Inf` and `-Inf` for floating point numbers already, we can just use them directly. It is memory more efficient and computational cheap.

Most importantly, we are going to release a BLAS package for tropical numbers, which is two orders faster than naive Julia loops. If a tropical number is defined as a composite data structure, it is hard to utilize SIMD.
