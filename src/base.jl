export Tropical, TropicalF64, TropicalF32, TropicalF16, content

neginf(::Type{T}) where T<:AbstractFloat = typemin(T)
neginf(::Type{T}) where T<:Rational = typemin(T)
neginf(::Type{T}) where T<:Integer = T(-999999)
neginf(::Type{T}) where T<:Int16 = T(-9999)

struct Tropical{T} <: Number
    n::T
    Tropical{T}(x) where T = new{T}(T(x))
    function Tropical(x::T) where T
        new{T}(x)
    end
    function Tropical{T}(x::Tropical{T}) where T
        x
    end
end

const TropicalF64 = Tropical{Float64}
const TropicalF32 = Tropical{Float32}
const TropicalF16 = Tropical{Float16}

function Base.show(io::IO, inf::Tropical)
    print(io,"Tropical($(inf.n))")
end

function Base.show(io::IO, ::MIME"text/plain", inf::Tropical)
    Base.show(io, inf)
end

content(x::Tropical) = x.n

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

for OP in [:>, :<, :(==), :>=, :<=, :isless]
    @eval Base.$OP(a::Tropical, b::Tropical) = $OP(a.n, b.n)
end

Base.isapprox(x::Tropical, y::Tropical; kwargs...) = isapprox(x.n, y.n; kwargs...)
Base.isapprox(x::AbstractArray{<:Tropical}, y::AbstractArray{<:Tropical}; kwargs...) = all(isapprox.(x, y; kwargs...))
