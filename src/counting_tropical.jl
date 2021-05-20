struct CountingTropical{T,CT} <: Number
    n::T
    c::CT
end
CountingTropical(x::T) where T<:Real = CountingTropical(x, T(1))
CountingTropical{T1}(x) where {T1} = CountingTropical{T1,T1}(x)

CountingTropical{T1,CT1}(x) where {T1, CT1} = CountingTropical{T1,CT1}(T1(x), CT1(1))
CountingTropical{T1,CT1}(x::CountingTropical{T1,CT1}) where {T1,CT1} = x
CountingTropical{T1,CT1}(x::CountingTropical) where {T1,CT1} = CountingTropical(T1(x.n), CT1(x.c))
CountingTropical{T1,CT1}(x::Tropical) where {T1,CT1} = CountingTropical{T1,CT1}(T1(TropicalNumbers.content(x)), CT1(1))

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
Base.zero(::Type{CountingTropical{T}}) where T = zero(CountingTropical{T,T})
Base.zero(::Type{CountingTropical{T,CT}}) where {T<:Integer,CT} = CountingTropical(T(-999999), CT(0))
Base.zero(::Type{CountingTropical{T,CT}}) where {T<:AbstractFloat,CT} = CountingTropical(typemin(T), CT(0))
Base.one(::Type{CountingTropical{T,CT}}) where {T<:Integer,CT} = CountingTropical(zero(T), CT(1))
Base.one(::Type{CountingTropical{T,CT}}) where {T<:AbstractFloat,CT} = CountingTropical(zero(T), CT(1))
Base.one(::T) where T<:CountingTropical = one(T)
Base.zero(::T) where T<:CountingTropical = zero(T)
Base.isapprox(a::CountingTropical, b::CountingTropical; kwargs...) = isapprox(a.n, b.n; kwargs...) && isapprox(a.c, b.c; kwargs...)

Base.show(io::IO, t::CountingTropical) = Base.print(io, "$((t.n, t.c))ₜ")

#Base.promote_type(::Type{CountingTropical{T1,CT1}}, b::Type{CountingTropical{T1,CT1}}) where {T1,CT1} = CountingTropical{T1, CT1}
Base.promote_type(::Type{CountingTropical{T1,CT1}}, b::Type{CountingTropical{T2,CT2}}) where {T1,T2,CT1,CT2} = CountingTropical{promote_type(T1,T2), promote_type(CT1,CT2)}
#Base.promote_type(::Type{CountingTropical{T1,CT1}}, b::Type{CountingTropical{T1,CT2}}) where {T1,CT1,CT2} = CountingTropical{T1, promote_rule(CT1,CT2)}
#Base.promote_type(::Type{CountingTropical{T1,CT1}}, b::Type{CountingTropical{T2,CT1}}) where {T1,T2,CT1} = CountingTropical{promote_rule(T1,T2), CT1}