export TropicalMaxMul, TropicalMaxMulF64, TropicalMaxMulF32, TropicalMaxMulF16, content

"""
    TropicalMaxMul{T} <: Number
    
TropicalMaxMul is a semiring algebra defined on x ∈ R⁺, which maps `+` to `max` in regular algebra

"""
struct TropicalMaxMul{T} <: Number
    n::T
    function TropicalMaxMul{T}(x) where T 
        @assert x >= 0
        new{T}(T(x))
    end
    function TropicalMaxMul(x::T) where T
        @assert x >= 0
        new{T}(x)
    end
    function TropicalMaxMul{T}(x::TropicalMaxMul{T}) where T
        @assert x.n >= 0
        x
    end
    function TropicalMaxMul{T1}(x::TropicalMaxMul{T2}) where {T1,T2}
        @assert x.n >= 0
        new{T1}(T2(x.n))
    end
end

Base.show(io::IO, t::TropicalMaxMul) = Base.print(io, "$(t.n)ₜ")

Base.:^(a::TropicalMaxMul, b::Real) = TropicalMaxMul(a.n ^ b)
Base.:^(a::TropicalMaxMul, b::Integer) = TropicalMaxMul(a.n ^ b)
Base.:*(a::TropicalMaxMul, b::TropicalMaxMul) = TropicalMaxMul(a.n * b.n)

Base.:+(a::TropicalMaxMul, b::TropicalMaxMul) = TropicalMaxMul(max(a.n, b.n))
Base.typemin(::Type{TropicalMaxMul{T}}) where T = zero(T)
Base.zero(::Type{TropicalMaxMul{T}}) where T = zero(T)
Base.zero(::TropicalMaxMul{T}) where T = zero(TropicalMaxMul{T})

Base.one(::Type{TropicalMaxMul{T}}) where T = TropicalMaxMul(one(T))
Base.one(::TropicalMaxMul{T}) where T = one(TropicalMaxMul{T})

# inverse and division
Base.inv(x::TropicalMaxMul{T}) where T = TropicalMaxMul(one(T) / x.n)
Base.:/(x::TropicalMaxMul, y::TropicalMaxMul) = TropicalMaxMul(x.n / y.n)
Base.div(x::TropicalMaxMul, y::TropicalMaxMul) = TropicalMaxMul(x.n ÷ y.n)

Base.isapprox(x::TropicalMaxMul, y::TropicalMaxMul; kwargs...) = TropicalMaxMul(x.n, y.n; kwargs...)

# promotion rules
Base.promote_type(::Type{TropicalMaxMul{T1}}, b::Type{TropicalMaxMul{T2}}) where {T1, T2} = TropicalMaxMul{promote_type(T1,T2)}
