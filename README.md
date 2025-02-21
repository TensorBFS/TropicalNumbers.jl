# TropicalNumbers

[![CI](https://github.com/TensorBFS/TropicalNumbers.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/TensorBFS/TropicalNumbers.jl/actions/workflows/ci.yml)
[![Codecov](https://codecov.io/gh/TensorBFS/TropicalNumbers.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/TensorBFS/TropicalNumbers.jl)

This package implements [tropical numbers](https://en.wikipedia.org/wiki/Tropical_geometry) and tropical algebras in Julia. Tropical algebra is also known as the [semiring](https://en.wikipedia.org/wiki/Semiring) algebra, which is a set $R$ equipped with two binary operations $\oplus$ and $\otimes$, called addition and multiplication, such that:

* $(R, \oplus)$ is a monoid with identity element called $\mathbb{0}$;
* $(R, \otimes)$ is a monoid with identity element called $\mathbb{1}$;
* Addition is commutative;
* Multiplication by the additive identity $\mathbb{0}$ annihilates ;
* Multiplication left- and right-distributes over addition;
* Explicitly stated, $(R, \oplus)$ is a commutative monoid.

## Installation
To install this package, press `]` in Julia REPL to enter package mode, then type

```julia
pkg> add TropicalNumbers
```

## Using

A Topical algebra can be described as a tuple $(R, \oplus, \otimes, \mathbb{0}, \mathbb{1})$, where $R$ is the set, $\oplus$ and $\otimes$ are the opeartions and $\mathbb{0}$, $\mathbb{1}$ are their identity element, respectively. In this package, the following tropical algebras are implemented:
* `TropicalAndOr`: $([T, F], \lor, \land, F, T)$;
* `Tropical` (`TropicalMaxPlus`): $(\mathbb{R}, \max, +, -\infty, 0)$;
* `TropicalMinPlus`: $(\mathbb{R}, \min, +, \infty, 0)$;
* `TropicalMaxMul`: $(\mathbb{R}^+, \max, \times, 0, 1)$.

```julia
julia> using TropicalNumbers

julia> Tropical(3) * Tropical(4)
Tropical(7)

julia> TropicalMaxMul(3) * TropicalMaxMul(4)
TropicalMaxMul(12)
```
> Warnings
> 1. `TropicalMaxPlus` is an alias of `Tropical`.
> 2. `TropicalMaxMul` should not contain negative numbers. However, this package does not check the data validity. Not only for performance reason, but also for future GPU support.

## Why another tropical number?

Related packages include

* [SimpleTropical.jl](https://github.com/scheinerman/SimpleTropical.jl)
* [TropicalSemiring.jl](https://github.com/saschatimme/TropicalSemiring.jl)

These packages include unnecessary fields in its tropical numbers, such as `isinf`. However, `Inf` and `-Inf` can be used directly for floating point numbers, which is more memory efficient and computationally cheap. `TropicalNumbers` is designed for high performance matrix multiplication on both CPU and GPU.

## Ecosystem
* [TropicalGEMM.jl](https://github.com/TensorBFS/TropicalGEMM.jl): The BLAS package for tropical numbers.
* [CuTropicalGEMM.jl](https://github.com/ArrogantGao/CuTropicalGEMM.jl), The GPU version of TropicalGEMM.
