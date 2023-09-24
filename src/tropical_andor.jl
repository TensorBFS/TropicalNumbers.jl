export TropicalAndOr

"""
    TropicalAndOr{T} <: Number
    
TropicalAndOr is a semiring algebra defined on Bool numbers, which maps `+` to `or` and `*` to `and` in regular algebra.

"""
struct TropicalAndOr <: Number
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
Base.isapprox(x::TropicalAndOr, y::TropicalAndOr; kwargs...) = ispprox(x.n, y.n; kwargs...)
