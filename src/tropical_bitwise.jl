"""
    TropicalBitwise{T} <: AbstractSemiring

TropicalBitwise is a semiring algebra, can be described by
* TropicalBitwise, (ℝ, |, &, 0, ~0).

It maps
* `+` to `|`
* `*` to `&`
* `0` to `0`
* `1` to ~0`

Example
-------------------------
```jldoctest; setup=:(using TropicalNumbers)
julia> TropicalBitwise(1) + TropicalBitwise(3)
3ₛ

julia> TropicalBitwise(1) * TropicalBitwise(3)
1ₛ

julia> zero(TropicalBitwiseI64)
0ₛ

julia> one(TropicalBitwiseI64)
-1ₛ
```
"""
struct TropicalBitwise{T} <: AbstractSemiring
    n::T
end

function TropicalBitwise(a::TropicalBitwise)
    return TropicalBitwise(a.n)
end

function TropicalBitwise{T}(a::TropicalBitwise) where {T}
    return TropicalBitwise{T}(a.n)
end

function Base.show(io::IO, a::TropicalBitwise)
    print(io, "$(a.n)ₛ")
    return
end

function Base.isapprox(a::TropicalBitwise, b::TropicalBitwise; kw...)
    return isapprox(a.n, b.n; kw...)
end

function Base.promote_rule(::Type{TropicalBitwise{U}}, ::Type{TropicalBitwise{V}}) where {U, V}
    W = promote_type(U, V)
    return TropicalBitwise{W}
end

function Base.:+(a::TropicalBitwise, b::TropicalBitwise)
    n = a.n | b.n
    return TropicalBitwise(n)
end

function Base.:*(a::TropicalBitwise, b::TropicalBitwise)
    n = a.n & b.n
    return TropicalBitwise(n)
end

function Base.zero(::Type{T}) where {T <: TropicalBitwise}
    return typemin(T)
end

function Base.zero(::T) where {T <: TropicalBitwise}
    return zero(T)
end

function Base.one(::Type{T}) where {T <: TropicalBitwise}
    return typemax(T)
end

function Base.one(::T) where {T <: TropicalBitwise}
    return one(T)
end

function Base.typemin(::Type{TropicalBitwise{T}}) where {T}
    n = zero(T)
    return TropicalBitwise(n)
end

function Base.typemax(::Type{TropicalBitwise{T}}) where {T}
    n = ~zero(T)
    return TropicalBitwise(n)
end

function Base.:(==)(a::TropicalBitwise, b::TropicalBitwise)
    return a.n == b.n
end

function Base.:>=(a::TropicalBitwise, b::TropicalBitwise)
    return b.n <= a.n
end

function Base.:<=(a::TropicalBitwise, b::TropicalBitwise)
    return a.n | b.n == b.n
end

function Base.:<(a::TropicalBitwise, b::TropicalBitwise)
    return a != b && a <= b
end

function Base.:>(a::TropicalBitwise, b::TropicalBitwise)
    return b < a
end
