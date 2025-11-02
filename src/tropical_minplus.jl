

"""
    TropicalMinPlus{T} <: AbstractSemiring

TropicalMinPlus is a semiring algebra, can be described by
* TropicalMinPlus, (ℝ, min, +, Inf, 0).

It maps
* `+` to `min` in regular algebra,
* `*` to `+` in regular algebra,
* `1` to `0` in regular algebra,
* `0` to `Inf` in regular algebra (for integer content types, this is chosen as a large integer).

Example
-------------------------
```jldoctest; setup=:(using TropicalNumbers)
julia> TropicalMinPlus(1.0) + TropicalMinPlus(3.0)
1.0ₛ

julia> TropicalMinPlus(1.0) * TropicalMinPlus(3.0)
4.0ₛ

julia> one(TropicalMinPlusF64)
0.0ₛ

julia> zero(TropicalMinPlusF64)
Infₛ
```
"""
struct TropicalMinPlus{T} <: AbstractSemiring
    n::T
    TropicalMinPlus{T}(x) where T = new{T}(T(x))
    function TropicalMinPlus(x::T) where T
        new{T}(x)
    end
    function TropicalMinPlus{T}(x::TropicalMinPlus{T}) where T
        x
    end
    function TropicalMinPlus{T1}(x::TropicalMinPlus{T2}) where {T1,T2}
        new{T1}(T2(x.n))
    end
end

Base.show(io::IO, t::TropicalMinPlus) = Base.print(io, "$(t.n)ₛ")

Base.:^(a::TropicalMinPlus, b::Real) = TropicalMinPlus(a.n * b)
Base.:^(a::TropicalMinPlus, b::Integer) = TropicalMinPlus(a.n * b)
Base.:*(a::TropicalMinPlus, b::TropicalMinPlus) = TropicalMinPlus(a.n + b.n)
function Base.:*(a::TropicalMinPlus{<:Rational}, b::TropicalMinPlus{<:Rational})
    if a.n.den == 0
        a
    elseif b.n.den == 0
        b
    else
        TropicalMinPlus(a.n + b.n)
    end
end

Base.:+(a::TropicalMinPlus, b::TropicalMinPlus) = TropicalMinPlus(min(a.n, b.n))
Base.typemin(::Type{TropicalMinPlus{T}}) where T = TropicalMinPlus(posinf(T))
Base.zero(::Type{TropicalMinPlus{T}}) where T = typemin(TropicalMinPlus{T})
Base.zero(::TropicalMinPlus{T}) where T = zero(TropicalMinPlus{T})

Base.one(::Type{TropicalMinPlus{T}}) where T = TropicalMinPlus(zero(T))
Base.one(::TropicalMinPlus{T}) where T = one(TropicalMinPlus{T})

# inverse and division
Base.inv(x::TropicalMinPlus) = TropicalMinPlus(-x.n)
Base.:/(x::TropicalMinPlus, y::TropicalMinPlus) = TropicalMinPlus(x.n - y.n)
Base.div(x::TropicalMinPlus, y::TropicalMinPlus) = TropicalMinPlus(x.n - y.n)

# ordering
function Base.:(==)(a::TropicalMinPlus, b::TropicalMinPlus)
    return b.n == a.n
end

function Base.:>=(a::TropicalMinPlus, b::TropicalMinPlus)
    return b.n >= a.n
end

function Base.:<=(a::TropicalMinPlus, b::TropicalMinPlus)
    return b.n <= a.n
end

function Base.:<(a::TropicalMinPlus, b::TropicalMinPlus)
    return b.n < a.n
end

function Base.:>(a::TropicalMinPlus, b::TropicalMinPlus)
    return b.n > a.n
end

function Base.isless(a::TropicalMinPlus, b::TropicalMinPlus)
    return isless(b.n, a.n)
end

Base.isapprox(x::TropicalMinPlus, y::TropicalMinPlus; kwargs...) = isapprox(x.n, y.n; kwargs...)

# promotion rules
Base.promote_rule(::Type{TropicalMinPlus{T1}}, b::Type{TropicalMinPlus{T2}}) where {T1, T2} = TropicalMinPlus{promote_type(T1,T2)}
