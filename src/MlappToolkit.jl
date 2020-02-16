module MlappToolkit

using Lazy

import Base: size

export

# 3. Generative Models for Discrete Data

## Types
Hypothesis,

## Methods
sequence,
pmf,
likelihood,
prior,
posterior

# Source files
include("GenerativeModels.jl")

end # module
