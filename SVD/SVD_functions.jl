function var_exp(X)
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
# std normalized SVD
x, y, namen = data_reading();
x, y = normalize_data(x, y, "std");
namen, x = remove_shit(x, namen);
var_exp_std = sort(var_exp(x));

# range normalized SVD
x, y, namen = data_reading();
x, y = normalize_data(x, y, "minmax");
namen, x = remove_shit(x, namen);
var_exp_mean = sort(var_exp(x));

# Non normalized SVD
x, y, namen = data_reading();
namen, x = remove_shit(x, namen);
var_exp_non = sort(var_exp(x));

normalized_x = 1:(2300/length(var_exp_std)):2300; 
plot(normalized_x, cumsum(var_exp_std))
normalized_x = 1:(2300/length(var_exp_mean)):2300; 
plot!(normalized_x, cumsum(var_exp_mean))
normalized_x = 1:(2300/length(var_exp_non)):2300; 
plot!(normalized_x, cumsum(var_exp_non))


data = CSV.read("Rel_res.csv", DataFrame)
plot(data[:, 2], seriestype=:scatter)


function node_finder(x, y)
    SSₑ = zeros(size(x)[1])
    for i in 1:size(x)[1]
        llocs = x .<= x[i]
        SSₑ_left = sum((y[llocs] .- mean(y[llocs])).^2)
        llocs = x .> x[i]
        SSₑ_right = sum((y[llocs] .- mean(y[llocs])).^2)
        SSₑ[i] = SSₑ_left + SSₑ_right
    end
    node = argmin(SSₑ)
    return node, SSₑ
end
node, SSₑ = node_finder(data[11:end, 1], data[11:end, 2])
plot(SSₑ)
node, SSₑ = node_finder(data[11:end, 3], data[11:end, 2])
plot(SSₑ)

