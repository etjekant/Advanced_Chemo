#Project Toxicity  (SVD)

using CSV, CurveFit, DataFrames, Distributions, GLM, HypothesisTests, Interpolations
using Juno, LinearAlgebra, MixedAnova, OrderedCollections, Peaks, Plots, Random

using RDatasets, ScikitLearn, StatsBase, Statistics, StatsPlots
@sk_import decomposition: PCA
@sk_import linear_model: LogisticRegression
@sk_import preprocessing: StandardScaler
@sk_import model_selection: train_test_split

function remove_shit(x_data, namen=[])
    # This function takes a Dataframe or Matrix as input. 
    # When a DataFrame is given "namen" can be left empty. When a 
    # Matrix is given, namen should be spicified. This makes sure the column headers
    # are known when working with the data. 
    if isempty(namen)
        namen = names(x_data)
    end
    namen = namen[vec(.!any(ismissing.(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any(ismissing.(Matrix(x_data)), dims=1))]
    namen = namen[vec(.!any(isnan.(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any(isnan.(Matrix(x_data)), dims=1))]
    namen = namen[vec(.!any(Inf.==(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any(Inf.==(Matrix(x_data)), dims=1))]
    namen = namen[vec(.!any((-Inf).==(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any((-Inf).==(Matrix(x_data)), dims=1))]
    return namen, x_data
end

data = CSV.read("/Users/ikram/Documents/Master/March-May 2022/Advanced Chemometrics and Statistics/Project /toxicity_data_fish_desc.csv", DataFrame)
descr = describe(data)

x = data[:, 8:end]
namen, x = remove_shit(x);
X = Matrix(x)
namen = namen

function varianceExplainedSVD(X, D, U, V)
	# initiate an empty array
	var_exp = zeros(size(D,1))  #Initialize an empty array (to save our information)
    i = 1
	for i = 1:size(D,1)
        println(i)
		#Copy D and set 1 value  to 0
		Dtemp = deepcopy(D) #Copy D, so it's a complete copy
		Dtemp[i,i] = 0  #Set the first singular value to 0
		XTX = X'*X #Not necessary --> recalculate the other variables
        D = diagm(sqrt.(abs.(eigvals(XTX))))
        V = eigvecs(XTX)
        U = X*V*pinv(D)	#Calculating U is necessary 
        X_hat = U*Dtemp*V'
		#Variance explained by remaining variables (all except i)
		var_exp[i] = (sum((X.-X_hat).^2)/sum(X.^2))
	end
	return var_exp
end

##Try github function##

function var_exp_svd(X)
    # This function is selfwritten and takes in the X-data. This function needs to be changes into Denises variant
    xt = transpose(X)*X
    V = eigvecs(xt)
    # had to use abs, the first values became small and negative
    # No column with a negative eigenvalue has been chosen.
    eigenvalues = abs.(eigvals(xt))
    D = diagm(sqrt.(eigenvalues))
    U = X*V*pinv(D)
    var_exp1 = zeros(size(D,1))
	for i = 1:size(D,1)
        println(i)
		#Copy D and set 1 value  to 0
		Dtemp = deepcopy(D)
		Dtemp[i,i] = 0
		X_hat = U*Dtemp*V'
		#Variance explained by remaining variables (all except i)
		var_exp1[i] = (sum((X.-X_hat).^2)/sum(X.^2))
	end
    return var_exp1
end


##End



# deactivate to run without mean centering
X = X .- mean(X,dims = 1)
# deactivate to run without scaling
X = X ./ std(X,dims=1)

out = svd(X)

D = diagm(out.S)
V = out.V
U = out.U

X_hat = U*D*V'
xt = X' * X
eigenvalues = abs.(eigvals(xt))
V = eigvecs(xt)
D = diagm(sqrt.(eigenvalues))
U = X*V*pinv(D)
var_exp = varianceExplainedSVD(X,D,U,V)	
## Try github function
var_exp = var_exp_svd(X)
plot_var_exp = scatter(var_exp)
##



plot_var_exp = plot(var_exp)

savefig(plot_var_exp) # save the most recent fig as fn
savefig(plot_ref, fn)

using JLD2

save("var_exp"; var_exp)
save_object("var_exp(X)", var_exp)

@save "var_exp" var_exp