"""
    TropicalMaxMin{T} <: AbstractSemiring

TropicalMaxMin is a semiring algebra, can be described by
* TropicalMaxMin, (ℝ, max, min, -Inf, Inf).

It maps
* `+` to `max` in regular algebra,
* `*` to `min` in regular algebra,
* `0` to `-Inf` in regular algebra (for integer content types, this is a small integer).
* `1` to `Inf` in regular algebra, (for integer content types, this is a large integer)

Example
-------------------------
```jldoctest; setup=:(using TropicalNumbers)
julia> TropicalMaxMin(1.0) + TropicalMaxMin(3.0)
3.0ₛ

julia> TropicalMaxMin(1.0) * TropicalMaxMin(3.0)
1.0ₛ

julia> zero(TropicalMaxMinF64)
-Infₛ

julia> one(TropicalMaxMinF64)
Infₛ
```
"""
struct TropicalMaxMin{T} <: AbstractSemiring
    n::T
end

function TropicalMaxMin(a::TropicalMaxMin)
    return TropicalMaxMin(a.n)
end

function TropicalMaxMin{T}(a::TropicalMaxMin) where {T}
    return TropicalMaxMin{T}(a.n)
end

function Base.show(io::IO, a::TropicalMaxMin)
    print(io, "$(a.n)ₛ")
    return
end

function Base.isapprox(a::TropicalMaxMin, b::TropicalMaxMin; kw...)
    return isapprox(a.n, b.n; kw...)
end

function Base.promote_rule(::Type{TropicalMaxMin{U}}, ::Type{TropicalMaxMin{V}}) where {U, V}
    W = promote_type(U, V)
    return TropicalMaxMin{W}
end

function Base.:+(a::TropicalMaxMin, b::TropicalMaxMin)
    n = max(a.n, b.n)
    return TropicalMaxMin(n)
end

function Base.:*(a::TropicalMaxMin, b::TropicalMaxMin)
    n = min(a.n, b.n)
    return TropicalMaxMin(n)
end

function Base.zero(::Type{T}) where {T <: TropicalMaxMin}
    return typemin(T)
end

function Base.zero(::T) where {T <: TropicalMaxMin}
    return zero(T)
end

function Base.one(::Type{T}) where {T <: TropicalMaxMin}
    return typemax(T)
end

function Base.one(::T) where {T <: TropicalMaxMin}
    return one(T)
end

function Base.typemin(::Type{TropicalMaxMin{T}}) where {T}
    n = neginf(T)
    return TropicalMaxMin(n)
end

function Base.typemax(::Type{TropicalMaxMin{T}}) where {T}
    n = posinf(T)
    return TropicalMaxMin(n)
end
