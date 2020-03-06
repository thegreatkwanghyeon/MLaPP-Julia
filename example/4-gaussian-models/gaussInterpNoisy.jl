using Random
using LinearAlgebra
using Plots
using Distributions

Random.seed!(4)

nInterval = 150
nObs = 10
λ = [30, 3]

perm = randperm(nInterval)

pointX = range(0, 1, length = 150) |> collect
obsIdx = perm[1:nObs]
hidIdx = perm[nObs+1:nInterval]

# Noisy observations
obsNoiseVar = 1
obs = sqrt(obsNoiseVar) * rand(Normal(0, 1), nObs)
A = zeros(nObs, nInterval)
for i in 1:nObs
    A[i, obsIdx[i]] = 1
end

# Build the matrix L
leftmost = vcat(-1, repeat([0], nInterval - 3))
offDiagonal = repeat([-1], nInterval - 3)
diagonal = repeat([2], nInterval - 2)
rightmost = vcat(repeat([0], nInterval - 3), -1)

result = plot(layout = length(λ), size=(1000, 600))

for i in 1:length(λ)

    L = Matrix(hcat(
        leftmost,
        Tridiagonal(offDiagonal, diagonal, offDiagonal),
        rightmost,
    )) * λ[i]

    # Estimation
    Λ = L' * L

    priorμ = zeros(nInterval)
    priorΣ = inv(Λ)

    obsΣ = obsNoiseVar * I
    obsΛ = inv(obsΣ)

    postΣ = inv(Λ + A' * obsΛ * A)
    postμ = postΣ * A' * obsΛ * obs

    band = postΣ |> diag .|> sqrt

    # Plotting
    plot!(
        title = "lambda = $(λ[i])",
        pointX,
        postμ,
        xticks = 0:0.1:1,
        ylims = (-5, 5),
        ribbon = band,
        fillcolor = :gray,
        color = :black,
        legend = false,
        grid = false,
        subplot = i
    )

    scatter!(
        pointX[obsIdx],
        obs,
        color = :black,
        markershape = :diamond,
        markersize = 5,
        subplot = i
    )

end

png(result, "figure-4-15")
