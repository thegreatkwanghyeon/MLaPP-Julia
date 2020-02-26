using MAT
using Plots
using DataFrames
using Statistics
using Distributions

data = matopen("example/data/heightWeight.mat")
heightWeight = read(data, "heightWeightData") |> x -> convert(DataFrame, x)

rename!(heightWeight, [:sex, :height, :weight])

male = filter(x -> x[:sex] == 1, heightWeight)
female = filter(x -> x[:sex] == 2, heightWeight)

pointX = 55:80
pointY = 80:280

μMale = aggregate(male[!, [:height, :weight]], mean) |> Array |> vec
μFemale = aggregate(female[!, [:height, :weight]], mean) |> Array |> vec
ΣMale = male[!, [:height, :weight]] |> Matrix |> cov
ΣFemale = male[!, [:height, :weight]] |> Matrix |> cov
normalMale = MvNormal(μMale, ΣMale)
normalFemale = MvNormal(μFemale, ΣFemale)



p1 = scatter(
    male.height,
    male.weight,
    markershape = :x,
    markercolor = :blue,
    title = "red = female, blue = male",
    xlims = (55, 80),
    ylims = (80, 280),
    xlabel = "height",
    ylabel = "weight",
    legend = false,
    grid = false,
)

scatter!(
    female.height,
    female.weight,
    markershape = :diamond,
    markercolor = :red
)


p2 = scatter(
    male.height,
    male.weight,
    markershape = :x,
    markercolor = :blue,
    title = "red = female, blue = male",
    xlims = (55, 80),
    ylims = (80, 280),
    xlabel = "height",
    ylabel = "weight",
    legend = false,
    grid = false,
)

scatter!(
    female.height,
    female.weight,
    markershape = :diamond,
    markercolor = :red
)

contour!(
    pointX,
    pointY,
    (x, y) -> pdf(normalMale, [x, y]),
    levels = [0.0005],
    linecolor = :blue
)

contour!(
    pointX,
    pointY,
    (x, y) -> pdf(normalFemale, [x, y]),
    levels = [0.0005],
    linecolor = :red
)

result = plot(p1, p2, grid = 2, size = (1200, 600))

png(result, "figure-4-2")

close(data)
