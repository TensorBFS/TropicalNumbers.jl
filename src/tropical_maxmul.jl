

"""
    TropicalMaxMul{T} <: AbstractSemiring

TropicalMaxMul is a semiring algebra, can be described by
* TropicalMaxMul, (ℝ⁺, max, ⋅, 0, 1).

It maps
* `+` to `max` in regular algebra,
* `*` to `*` in regular algebra,
* `1` to `1` in regular algebra,
* `0` to `0` in regular algebra.

Example
-------------------------
```jldoctest; setup=:(using TropicalNumbers)
julia> TropicalMaxMul(1.0) + TropicalMaxMul(3.0)
3.0ₓ

julia> TropicalMaxMul(1.0) * TropicalMaxMul(3.0)
3.0ₓ

julia> one(TropicalMaxMulF64)
1.0ₓ

julia> zero(TropicalMaxMulF64)
0.0ₓ
```
"""
struct TropicalMaxMul{T} <: AbstractSemiring
    n::T
    function TropicalMaxMul{T}(x) where T 
        new{T}(T(x))
    end
    function TropicalMaxMul(x::T) where T
        new{T}(x)
    end
    function TropicalMaxMul{T}(x::TropicalMaxMul{T}) where T
        x
    end
    function TropicalMaxMul{T1}(x::TropicalMaxMul{T2}) where {T1,T2}
        new{T1}(T2(x.n))
    end
end

Base.show(io::IO, t::TropicalMaxMul) = Base.print(io, "$(t.n)ₓ")

Base.:^(a::TropicalMaxMul, b::Real) = TropicalMaxMul(a.n ^ b)
Base.:^(a::TropicalMaxMul, b::Integer) = TropicalMaxMul(a.n ^ b)
Base.:*(a::TropicalMaxMul, b::TropicalMaxMul) = TropicalMaxMul(a.n * b.n)

Base.:+(a::TropicalMaxMul, b::TropicalMaxMul) = TropicalMaxMul(max(a.n, b.n))
Base.typemin(::Type{TropicalMaxMul{T}}) where T = TropicalMaxMul(zero(T))
Base.typemax(::Type{TropicalMaxMul{T}}) where T = TropicalMaxMul(posinf(T))
Base.zero(::Type{TropicalMaxMul{T}}) where T = TropicalMaxMul(zero(T))
Base.zero(::TropicalMaxMul{T}) where T = zero(TropicalMaxMul{T})

Base.one(::Type{TropicalMaxMul{T}}) where T = TropicalMaxMul(one(T))
Base.one(::TropicalMaxMul{T}) where T = one(TropicalMaxMul{T})

# inverse and division
Base.inv(x::TropicalMaxMul{T}) where T = TropicalMaxMul(one(T) / x.n)
Base.:/(x::TropicalMaxMul, y::TropicalMaxMul) = TropicalMaxMul(x.n / y.n)
Base.div(x::TropicalMaxMul, y::TropicalMaxMul) = TropicalMaxMul(x.n ÷ y.n)

Base.isapprox(x::TropicalMaxMul, y::TropicalMaxMul; kwargs...) = isapprox(x.n, y.n; kwargs...)

# promotion rules
Base.promote_rule(::Type{TropicalMaxMul{T1}}, b::Type{TropicalMaxMul{T2}}) where {T1, T2} = TropicalMaxMul{promote_type(T1,T2)}
