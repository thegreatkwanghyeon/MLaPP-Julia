module MlappToolkit

using Lazy

import Base: size

export

# 3. Generative Models for Discrete Data

## Types
Hypothesis,

## Methods
createHypSpace,
pmf,
likelihood,
prior,
posterior

# Source files
include("GenerativeModels.jl")

end # module
