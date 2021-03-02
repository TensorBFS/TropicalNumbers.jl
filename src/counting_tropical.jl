struct CountingTropical{T} <: Number
    n::T
    c::T
end
CountingTropical(x::T) where T<:Real = CountingTropical(x, T(1))
CountingTropical{T1}(x::T2) where {T1, T2} = CountingTropical{T1}(T1(x), T1(1))
CountingTropical{T1}(x::CountingTropical{T1}) where {T1} = x
CountingTropical{T1}(x::Tropical{T2}) where {T1, T2} = CountingTropical(T1(TropicalNumbers.content(x)), T1(1))

Base.:*(a::CountingTropical, b::CountingTropical) = CountingTropical(a.n + b.n, a.c * b.c)
function Base.:+(a::CountingTropical, b::CountingTropical)
    n = max(a.n, b.n)
    if a.n > b.n
        c = a.c
    elseif a.n == b.n
        c =  a.c + b.c
    else
        c = b.c
    end
    CountingTropical(n, c)
end
Base.zero(::Type{CountingTropical{T}}) where T<:Integer = CountingTropical(T(-999999), T(1))
Base.zero(::Type{CountingTropical{T}}) where T<:AbstractFloat = CountingTropical(typemin(T), T(1))
Base.one(::Type{CountingTropical{T}}) where T<:Integer = CountingTropical(zero(T), T(1))
Base.one(::Type{CountingTropical{T}}) where T<:AbstractFloat = CountingTropical(zero(T), T(1))
Base.one(x::T) where T<:CountingTropical = one(T)
Base.zero(x::T) where T<:CountingTropical = zero(T)
Base.isapprox(a::CountingTropical, b::CountingTropical; kwargs...) = isapprox(a.n, b.n; kwargs...) && isapprox(a.c, b.c; kwargs...)

TropicalNumbers.content(x::CountingTropical) = x.n
TropicalTypes{T} = Union{CountingTropical{T}, Tropical{T}}

Base.show(io::IO, t::CountingTropical) = Base.print(io, "$((t.n, t.c))ₜ")
Base.show(io::IO, ::MIME"text/plain", t::CountingTropical) = Base.show(io, t)
