function suffle_PCA(X1, alpha=0.05)
    # Need to add sorting of the data. in our case this does not matter. but might be needed for other data
    significant_columns = 0
    # doing the eigenvalue decomposition
    cov_m = cov(X1);
    eigval = eigvals(cov_m)
    eigvec =  eigvecs(cov_m);
    # making the loadings and scores to perform deflation in the loop.
    loadings = eigvec;
    scores = (loadings'*X1')' 
    # looping over the whole dataset. This is because all columns can be significant.
    # There is a break statment when the first column is not significant anymore.
    for i in 1:size(X1)[2]
        # return_data is used to sture the eigenvalues of the datset.
        return_data = []
        for j in 1:50
            # suffle the dataset on each itteration.
            for col in eachcol(X1)
                shuffle!(col)
            end
            # printing where it is, this is done because it is soooo slow.
            println("$i, $j")
            cov_m = cov(X1);
            # only appending the eigenvalue of the column of interest.
            eigval_in = eigvals(cov_m)[end-i+1];
            push!(return_data, eigval_in)
        end
    # calculating the one sided confidence interval. 
    mean_return = mean(return_data)
    std_return = std(return_data)
    t_crit = quantile(TDist(length(return_data)), 1-alpha/2)
    upper = mean_return + std_return * t_crit
    # breaking when the column in not significant, real eigenvalue is lower than upper limit of the random value.
    if eigval[end-i+1] < upper
        break
    end
    # if the column is significant, the number gets updated
    significant_columns = i
    # deflating the matrix
    X1 = X1 - scores * loadings' 
    end
    # returns an range of the columns to select
    return significant_columns:size(X1)[2]
end

