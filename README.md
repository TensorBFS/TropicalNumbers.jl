# TropicalNumbers

Tropical number algebra, still under development.

[![Build Status](https://travis-ci.com/TensorBFS/TropicalNumbers.jl.svg?branch=master)](https://travis-ci.com/TensorBFS/TropicalNumbers.jl)
[![Codecov](https://codecov.io/gh/TensorBFS/TropicalNumbers.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/TensorBFS/TropicalNumbers.jl)

## To start

```julia
pkg> add TropicalNumbers
```

## Semiring and Tropical Algebras

A [`Semiring`](https://en.wikipedia.org/wiki/Semiring) is a set R equipped with two binary operations + and ⋅, called addition and multiplication, such that:

* (R, +) is a monoid with identity element called 0;
* (R, ⋅) is a monoid with identity element called 1;
* Addition is commutative;
* Multiplication by the additive identity 0 annihilates ;
* Multiplication left- and right-distributes over addition;
* Explicitly stated, (R, +) is a commutative monoid.

[`Tropical number`](https://en.wikipedia.org/wiki/Tropical_geometry) are a set of semiring algebras, described as 
* (R, +, ⋅, 0, 1).
where R is the set, + and ⋅ are the opeartions and 0, 1 are their identity element, respectively.

In this package, the following tropical algebras are implemented:
* TropicalAndOr, ([T, F], or, and, false, true);
* Tropical (TropicalMaxPlus), (ℝ, max, +, -Inf, 0);
* TropicalMinPlus, (ℝ, min, +, Inf, 0);
* TropicalMaxMul, (ℝ⁺, max, ⋅, 0, 1).

## Why another tropical number?

Related packages includes

* [SimpleTropical.jl](https://github.com/scheinerman/SimpleTropical.jl)
* [TropicalSemiring.jl](https://github.com/saschatimme/TropicalSemiring.jl)

Tropical numbers in these packages contains an extra field `isinf`. Which is not nessesary because we have `Inf` and `-Inf` for floating point numbers already, we can just use them directly. It is memory more efficient and computational cheap.

Most importantly, we are going to release a BLAS package for tropical numbers, which is two orders faster than naive Julia loops. If a tropical number is defined as a composite data structure, it is hard to utilize SIMD.

## Ecosystem
* [TropicalGEMM](https://github.com/TensorBFS/TropicalGEMM.jl), Tropical matrix multiplication with close to optimal speed.