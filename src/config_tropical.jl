# StaticBitVector
export StaticBitVector

struct StaticBitVector{N,C}
    data::NTuple{C,UInt64}
end
function StaticBitVector(x::AbstractVector)
    N = length(x)
    StaticBitVector{N,_nints(N)}((convert(BitVector, x).chunks...,))
end
function Base.convert(::Type{StaticBitVector{N,C}}, x::AbstractVector) where {N,C}
    @assert length(x) == N
    StaticBitVector(x)
end
_nints(x) = (x-1)÷64+1
Base.length(::StaticBitVector{N,C}) where {N,C} = N
Base.:(==)(x::StaticBitVector, y::AbstractVector) = [x...] == [y...]
Base.:(==)(x::AbstractVector, y::StaticBitVector) = [x...] == [y...]
Base.:(==)(x::StaticBitVector, y::StaticBitVector) = [x...] == [y...]
function Base.getindex(x::StaticBitVector{N,C}, i::Integer) where {N,C}
    i -= 1
    ii = i ÷ 64
    (x.data[ii+1] >> (i-ii*64)) & 1
end
Base.:(|)(x::StaticBitVector{N,C}, y::StaticBitVector{N,C}) where {N,C} = StaticBitVector{N,C}(x.data .| y.data)
Base.:(&)(x::StaticBitVector{N,C}, y::StaticBitVector{N,C}) where {N,C} = StaticBitVector{N,C}(x.data .& y.data)
Base.:(⊻)(x::StaticBitVector{N,C}, y::StaticBitVector{N,C}) where {N,C} = StaticBitVector{N,C}(x.data .⊻ y.data)
@generated function staticfalses(::Type{StaticBitVector{N,C}}) where {N,C}
    Expr(:call, :(StaticBitVector{$N,$C}), Expr(:tuple, zeros(UInt64, C)...))
end
@generated function statictrues(::Type{StaticBitVector{N,C}}) where {N,C}
    Expr(:call, :(StaticBitVector{$N,$C}), Expr(:tuple, fill(typemax(UInt64), C)...))
end
function onehot(::Type{StaticBitVector{N,C}}, i) where {N,C}
    x = falses(N)
    x[i] = true
    return StaticBitVector(x)
end
function Base.iterate(x::StaticBitVector{N,C}, state=1) where {N,C}
    if state > N
        return nothing
    else
        return x[state], state+1
    end
end

struct ConfigTropical{T,N,C} <: Number
    n::T
    config::StaticBitVector{N,C}
end
ConfigTropical(x::T, config::AbstractVector) where T<:Real = ConfigTropical{T,length(config), _nints(length(config))}(x, config)

Base.:(==)(x::ConfigTropical{T,N}, y::ConfigTropical{T,N}) where {T,N} = x.n == y.n && x.config == y.config

function Base.:+(x::ConfigTropical{T,N}, y::ConfigTropical{T,N}) where {T,N}
    return x.n > y.n ? x : y
end

function Base.:*(x::ConfigTropical{T,L,C}, y::ConfigTropical{T,L,C}) where {T,L,C}
    return ConfigTropical{T,L,C}(x.n+y.n, x.config | y.config)
end

Base.zero(::Type{ConfigTropical{T,N,C}}) where {T,N,C} = ConfigTropical{T,N,C}(zero(Tropical{T}).n, statictrues(StaticBitVector{N,C}))
Base.one(::Type{ConfigTropical{T,N,C}}) where {T,N,C} = ConfigTropical{T,N,C}(one(Tropical{T}).n, staticfalses(StaticBitVector{N,C}))
Base.zero(::T) where T<:ConfigTropical = zero(T)
Base.one(::T) where T<:ConfigTropical = one(T)

Base.isapprox(a::ConfigTropical, b::ConfigTropical; kwargs...) = isapprox(a.n, b.n; kwargs...) && (a.config == b.config)
Base.show(io::IO, t::StaticBitVector) = Base.print(io, "$(join(Int.(t), ""))")
Base.show(io::IO, t::ConfigTropical) = Base.print(io, "$(t.n)ₜ ~ $(t.config)")
Base.promote_type(::Type{ConfigTropical{T1,N}}, b::Type{ConfigTropical{T2,N}}) where {T1,T2,N} = ConfigTropical{promote_type(T1,T2), N}