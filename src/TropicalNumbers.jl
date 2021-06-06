module TropicalNumbers

export Tropical, TropicalF64, TropicalF32, TropicalF16, CountingTropicalF16, CountingTropicalF32, CountingTropicalF64, content
export CountingTropical, ConfigTropical
export TropicalTypes


include("tropical.jl")
include("counting_tropical.jl")
include("config_tropical.jl")

const TropicalTypes{T} = Union{CountingTropical{T}, ConfigTropical{T}, Tropical{T}}

# alias
for NBIT in [16, 32, 64]
    @eval const $(Symbol(:Tropical, :F, NBIT)) = Tropical{$(Symbol(:Float, NBIT))}
    @eval const $(Symbol(:CountingTropical, :F, NBIT)) = CountingTropical{$(Symbol(:Float, NBIT)),$(Symbol(:Float, NBIT))}
    @eval const $(Symbol(:ConfigTropical, :F, NBIT)){N,C} = ConfigTropical{$(Symbol(:Float, NBIT)),N,C}
end

# alias
for T in [:Tropical, :CountingTropical, :ConfigTropical]
    # defining constants like `TropicalF64`.
    for OP in [:>, :<, :(==), :>=, :<=, :isless]
        @eval Base.$OP(a::$T, b::$T) = $OP(a.n, b.n)
    end
    @eval begin
        content(x::$T) = x.n
        content(x::Type{$T{X}}) where X = X
        Base.isapprox(x::AbstractArray{<:$T}, y::AbstractArray{<:$T}; kwargs...) = all(isapprox.(x, y; kwargs...))
        Base.show(io::IO, ::MIME"text/plain", t::$T) = Base.show(io, t)

        # this is for CUDA matmul
        Base.:(*)(a::$T, b::Bool) = b ? a : zero(a)
        Base.:(*)(b::Bool, a::$T) = b ? a : zero(a)
        Base.:(/)(a::$T, b::Bool) = b ? a : a / zero(a)
        Base.:(/)(b::Bool, a::$T) = b ? inv(a) : zero(a)
        Base.div(a::$T, b::Bool) = b ? a : a / zero(a)
        Base.div(b::Bool, a::$T) = b ? inv(a) : zero(a)
    end
end

end # module
