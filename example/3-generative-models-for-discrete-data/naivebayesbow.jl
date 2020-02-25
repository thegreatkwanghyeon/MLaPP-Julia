using MAT

data = matopen("example/data/XwindowsDocData.mat")

vocab = read(data, "vocab")
xtrain = read(data, "xtrain")
ytrain = read(data, "ytrain")
xtest = read(data, "xtest")
ytest = read(data, "ytest")

pseudoCount = 1
nClass = ytrain |> unique |> length

result = plot(layout = nClass)

for i = 1:nClass
      nCase = vec(ytrain .== i) |> sum
      nOn = findall(vec(ytrain) .== i) |>
            x -> xtrain[x, :] |> x -> sum(x, dims = 1)
      nOff = nCase .- nOn
      bar!(
           vec((nOn .+ pseudoCount) ./ (nOn + nOff .+ pseudoCount * 2)),
           title = "p(xj=1 | y=$i)",
           subplot = i,
           legend = false,
           grid = false,
           yticks = 0:0.1:1
      )
end

png(result, "figure-3-8")

close(data)
