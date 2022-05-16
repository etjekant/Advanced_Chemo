# This document should provide every package you need for our julia project. If not, please at the packages and update this file
using CSV, CurveFit, DataFrames, Distributions, GLM, HypothesisTests, Interpolations
using Juno, LinearAlgebra, MixedAnova, OrderedCollections, Peaks, Plots, Random
using RDatasets, ScikitLearn, StatsBase, Statistics, StatsPlots
@sk_import decomposition: PCA
@sk_import linear_model: LogisticRegression
@sk_import preprocessing: StandardScaler
@sk_import model_selection: train_test_split
@sk_import ensemble: RandomForestClassifier
@sk_import ensemble: RandomForestRegressor
@sk_import model_selection: train_test_split;
include("General_functions.jl")
include("./PCA/PCA_functions.jl")
include("./SVD/SVD_functions.jl")
include("./MCR/MCR_functions.jl")
include("./TREE/TREE_functions.jl")


data = CSV.read("ConcData.csv", DataFrame)
data = vec(Matrix(data))
normal_dist = Normal(mean(data), std(data))
gamma_dist = fit_mle(Gamma, data)
plot(gamma_dist)
plot!(normal_dist)
histogram!(data, bins=5, normalize=true, alpha=0.5)

loop_vector = collect(9:0.01:10)
return_vector = zeros(length(collect(9:0.01:10)))
for i in eachindex(loop_vector)
    normal_chance = pdf(normal_dist, i)
    gamma_chance = pdf(gamma_dist, i)
    return_vector[i] = normal_chance*gamma_chance
    Plots.display(plot(loop_vector, return_vector))
end
