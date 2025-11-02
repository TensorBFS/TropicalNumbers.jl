

"""
    TropicalAndOr <: Number

TropicalAndOr is a semiring algebra, can be described by
* TropicalAndOr, ([T, F], or, and, false, true).

It maps
* `+` to `or` in regular algebra,
* `*` to `and` in regular algebra,
* `1` to `true` in regular algebra,
* `0` to `false` in regular algebra.

For the parallel bit-wise version, see [`TropicalBitwise`](@ref).

Example
-------------------------
```jldoctest; setup=:(using TropicalNumbers)
julia> TropicalAndOr(true) + TropicalAndOr(false)
trueₜ

julia> TropicalAndOr(true) * TropicalAndOr(false)
falseₜ

julia> one(TropicalAndOr)
trueₜ

julia> zero(TropicalAndOr)
falseₜ
```
"""
struct TropicalAndOr <: AbstractSemiring
    n::Bool
    TropicalAndOr(x::T) where T <: Bool = new(x)
end

Base.show(io::IO, t::TropicalAndOr) = Base.print(io, "$(t.n)ₜ")

Base.:*(a::TropicalAndOr, b::TropicalAndOr) = TropicalAndOr(a.n && b.n)

Base.:+(a::TropicalAndOr, b::TropicalAndOr) = TropicalAndOr(a.n || b.n)

Base.typemin(::Type{TropicalAndOr}) = TropicalAndOr(false)
Base.zero(::Type{TropicalAndOr}) = typemin(TropicalAndOr)
Base.zero(::TropicalAndOr) = zero(TropicalAndOr)

Base.one(::Type{TropicalAndOr}) = TropicalAndOr(true)
Base.one(::TropicalAndOr) = one(TropicalAndOr)

# inverse and division
Base.inv(x::TropicalAndOr) = TropicalAndOr(!x.n)

# bool type only have two values
Base.isapprox(x::TropicalAndOr, y::TropicalAndOr; kwargs...) = isapprox(x.n, y.n; kwargs...)
