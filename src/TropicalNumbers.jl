module TropicalNumbers

export Tropical, TropicalF64, TropicalF32, TropicalF16, content
export CountingTropical
export TropicalTypes


include("base.jl")
include("counting_tropical.jl")

# this is for CUDA matmul
Base.:(*)(a::TropicalTypes, b::Bool) = b ? a : zero(a)
Base.:(*)(b::Bool, a::TropicalTypes) = b ? a : zero(a)

end # module
