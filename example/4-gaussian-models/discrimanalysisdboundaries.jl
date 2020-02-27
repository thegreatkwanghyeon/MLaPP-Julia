using Random
using Distributions
using Plots

Random.seed!(3)
nSample = 30

# Gaussian sampling
μA = [1.0; 1.0]
ΣA = [1.5 0; 0 1.0]
modelA = MvNormal(μA, ΣA)
sampleA = rand(modelA, nSample)

μB = [-1.0; -1.0]
ΣB = [0.7 0; 0 0.7]
modelB = MvNormal(μB, ΣB)
sampleB = rand(modelB, nSample)

# Plotting
predictFunction = (A, B) -> ((x, y) -> (pdf(A, [x, y]) > pdf(B, [x, y])) ? 1 : 2)
pointX = -3:0.01:3
pointY = -3:0.01:3

result = contour(
    title = "Parabolic boundary",
    pointX,
    pointY,
    predictFunction(modelA, modelB),
    xlims = (-3, 3),
    ylims = (-3, 3),
    fill = true,
    color = cgrad([:orange, :blue]),
    legend = false
)

scatter!(
    sampleA[1, :],
    sampleA[2, :],
    color = :orange
)

scatter!(
    sampleB[1, :],
    sampleB[2, :],
    color = :blue
)

png(result, "figure-4-3")
