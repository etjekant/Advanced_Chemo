using LinearAlgebra, Random, Plots, Statistics, CSV, DataFrames


function varianceExplainedSVD(X,D, U, V)
	# initiate an empty array
	var_exp = zeros(size(D,1))
	for i = 1:size(D,1)
		#Copy D and set 1 value  to 0
		Dtemp = deepcopy(D)
		Dtemp[i,i] = 0
		X_hat = U*Dtemp*V'
		#Variance explained by remaining variables (all except i)
		var_exp[i] = (sum((X.-X_hat).^2)/sum(X.^2))
	end
	return var_exp
end


## Extensive exersize

data = CSV.read("C:\\Users\\dherwer\\OneDrive - UvA\\ACS_2022\\Lectures\\L2-SVD\\mtcars.csv",DataFrame)
X = Matrix(data[:,2:end-1])
class = data[:,end]

# deactivate to run without mean centering
X = X .- mean(X,dims = 1)
# deactivate to run without scaling
X = X ./ std(X,dims=1)


out = svd(X)

D = diagm(out.S)
V = out.V
U = out.U

X_hat = U*D*V'

var_exp = varianceExplainedSVD(X,D,U,V)		#select 2 singular values to describe the full dataset


# look at the loadings to find the most important variables
bar(V[:,end-1:end], fillalpha = 0.75)


# both cases have the most important loadings for var 3 and 4 (i.e., disp and HP)
#plot for first SV
Dtemp = zeros(size(D))
Dtemp[end,end] = D[end,end]

X_hat = U*Dtemp*V'				# X_hat only calculated with first SV


scatter(X[:,4],X[:,3], group = class)
scatter!(X_hat[:,4],X_hat[:,3])


#plot for second SV
Dtemp = zeros(size(D))
Dtemp[end-1,end-1] = D[end-1,end-1]

X_hat = U*Dtemp*V'


scatter(X[:,4],X[:,3], group = class)
scatter!(X_hat[:,4],X_hat[:,3])



#scores (either use U or U*Dtemp)
Dtemp = zeros(size(D))
Dtemp[end-1,end-1] = D[end-1,end-1]
Dtemp[end,end] = D[end,end]

X_hat = U*Dtemp*V'
scatter((U*Dtemp)[:,end],(U*Dtemp)[:,end-1], group = class)
