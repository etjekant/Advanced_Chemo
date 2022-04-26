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
