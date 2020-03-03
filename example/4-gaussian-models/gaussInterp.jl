using Random
using LinearAlgebra
using Plots

Random.seed!(33)

nInterval = 150
nObs = 10
λ = [30, 10]

perm = randperm(nInterval)

pointX = range(0, 1, length = 150) |> collect
obsIdx = perm[1:nObs]
hidIdx = perm[nObs+1:nInterval]
obs = rand(nObs)

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

    L1 = L[:, hidIdx]
    L2 = L[:, obsIdx]
    Λ11 = transpose(L1) * L1
    Λ12 = transpose(L1) * L2

    posteriorμ = -inv(Λ11) * Λ12 * obs
    posteriorΣ = inv(Λ11)

    band = zeros(nInterval)
    band[hidIdx] = 2 * diag(posteriorΣ)


    x̄ = zeros(nInterval)
    x̄[hidIdx] = posteriorμ
    x̄[obsIdx] = obs

    plot!(
        title = "lambda = $(λ[i])",
        pointX,
        x̄,
        ribbon = band,
        xticks = 0:0.1:1,
        ylims = (-5, 5),
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

png(result, "figure-4-10")
