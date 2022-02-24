export Tropical, TropicalF64, TropicalF32, TropicalF16, content

neginf(::Type{T}) where T = typemin(T)
neginf(::Type{T}) where T<:AbstractFloat = typemin(T)
neginf(::Type{T}) where T<:Rational = typemin(T)
neginf(::Type{T}) where T<:Integer = T(-999999)
neginf(::Type{Int16}) = Int16(-16384)
neginf(::Type{Int8}) = Int8(-64)

"""
    Tropical{T} <: Number
    
[Tropical number](https://en.wikipedia.org/wiki/Tropical_geometry) is a semiring algebra that maps

* `+` in regular algebra to `max`,
* `*` in regular algebra to `+`,
* `1` in regular algebra to `0`,
* `0` in regular algebra to `-Inf` (for integer content types, this is chosen as a mall integer).

We implemented fast tropical matrix multiplication in [`TropicalGEMM`](https://github.com/TensorBFS/TropicalGEMM.jl/).

Example
-------------------------
```jldoctest; setup=:(using TropicalNumbers)
julia> Tropical(1.0) + Tropical(3.0)
3.0ₜ

julia> Tropical(1.0) * Tropical(3.0)
4.0ₜ

julia> one(TropicalF64)
0.0ₜ

julia> zero(TropicalF64)
-Infₜ
```
"""
struct Tropical{T} <: Number
    n::T
    Tropical{T}(x) where T = new{T}(T(x))
    function Tropical(x::T) where T
        new{T}(x)
    end
    function Tropical{T}(x::Tropical{T}) where T
        x
    end
    function Tropical{T1}(x::Tropical{T2}) where {T1,T2}
        new{T1}(T2(x.n))
    end
end

Base.show(io::IO, t::Tropical) = Base.print(io, "$(t.n)ₜ")

Base.:^(a::Tropical, b::Real) = Tropical(a.n * b)
Base.:^(a::Tropical, b::Integer) = Tropical(a.n * b)
Base.:*(a::Tropical, b::Tropical) = Tropical(a.n + b.n)
function Base.:*(a::Tropical{<:Rational}, b::Tropical{<:Rational})
    if a.n.den == 0
        a
    elseif b.n.den == 0
        b
    else
        Tropical(a.n + b.n)
    end
end
Base.:+(a::Tropical, b::Tropical) = Tropical(max(a.n, b.n))
Base.zero(::Type{Tropical{T}}) where T = Tropical(neginf(T))
Base.zero(::Tropical{T}) where T = zero(Tropical{T})

Base.one(::Type{Tropical{T}}) where T = Tropical(zero(T))
Base.one(::Tropical{T}) where T = one(Tropical{T})

# inverse and division
Base.inv(x::Tropical) = Tropical(-x.n)
Base.:/(x::Tropical, y::Tropical) = Tropical(x.n - y.n)
Base.div(x::Tropical, y::Tropical) = Tropical(x.n - y.n)

Base.isapprox(x::Tropical, y::Tropical; kwargs...) = isapprox(x.n, y.n; kwargs...)

# promotion rules
Base.promote_type(::Type{Tropical{T1}}, b::Type{Tropical{T2}}) where {T1, T2} = Tropical{promote_type(T1,T2)}
