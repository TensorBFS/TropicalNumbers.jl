struct CountingTropical{T,CT} <: Number
    n::T
    c::CT
end
CountingTropical(x::T) where T<:Real = CountingTropical(x, one(T))
CountingTropical{T1}(x) where {T1} = CountingTropical{T1,T1}(x)

CountingTropical{T1,CT1}(x) where {T1, CT1} = CountingTropical{T1,CT1}(T1(x), one(CT1))
CountingTropical{T1,CT1}(x::CountingTropical{T1,CT1}) where {T1,CT1} = x
CountingTropical{T1,CT1}(x::CountingTropical) where {T1,CT1} = CountingTropical(T1(x.n), CT1(x.c))
CountingTropical{T1,CT1}(x::Tropical) where {T1,CT1} = CountingTropical{T1,CT1}(T1(TropicalNumbers.content(x)), one(CT1))

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
# inverse and division
Base.inv(x::CountingTropical) = CountingTropical(-x.n, x.c)

Base.zero(::Type{CountingTropical{T}}) where T = zero(CountingTropical{T,T})
Base.zero(::Type{CountingTropical{T,CT}}) where {T<:Integer,CT} = CountingTropical(T(-999999), zero(CT))
Base.zero(::Type{CountingTropical{T,CT}}) where {T<:AbstractFloat,CT} = CountingTropical(typemin(T), zero(CT))
Base.zero(::T) where T<:CountingTropical = zero(T)
Base.one(::Type{CountingTropical{T}}) where T = one(CountingTropical{T,T})
Base.one(::Type{CountingTropical{T,CT}}) where {T<:Integer,CT} = CountingTropical(zero(T), one(CT))
Base.one(::Type{CountingTropical{T,CT}}) where {T<:AbstractFloat,CT} = CountingTropical(zero(T), one(CT))
Base.one(::T) where T<:CountingTropical = one(T)
Base.isapprox(a::CountingTropical, b::CountingTropical; kwargs...) = isapprox(a.n, b.n; kwargs...) && isapprox(a.c, b.c; kwargs...)

Base.show(io::IO, t::CountingTropical) = Base.print(io, "$((t.n, t.c))ₜ")

Base.promote_type(::Type{CountingTropical{T1,CT1}}, b::Type{CountingTropical{T2,CT2}}) where {T1,T2,CT1,CT2} = CountingTropical{promote_type(T1,T2), promote_type(CT1,CT2)}
