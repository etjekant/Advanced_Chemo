path = "C:\\Users\\etien\\OneDrive\\Documenten\\Data\\CSV\\";
# Shuffle PCA code
data = CSV.read(path*"toxicity_data_fish_desc.csv", DataFrame)
# Making the x_values
x = data[:, 8:end];
namen, x = remove_shit(x);
x = Matrix(x)
namen = namen
# normalizing the data
X1 = ;
namen, X1 = remove_shit(X1, namen);
# Prepare the y_values
y = data[:, 6];
# Calculating the eigenvalues, they are used to compare
# if the values are significant
# Partial least square discrimination analysis
suffle_PCA(X1)


function suffle_PCA(X1, alpha=0.05)
    significant_columns = 0
    cov_m = cov(X1);
    eigval = eigvals(cov_m)
    eigvec =  eigvecs(cov_m);
    loadings = eigvec;
    scores = (loadings'*X1')' 
    for i in 1:size(X1)[2]
        return_data = []
        for j in 1:50
            for col in eachcol(X1)
                shuffle!(col)
            end
            println("$i, $j")
            cov_m = cov(X1);
            eigval_in = eigvals(cov_m)[end-i+1];
            push!(return_data, eigval_in)
        end
    mean_return = mean(return_data)
    std_return = std(return_data)
    t_crit = quantile(TDist(length(return_data)), 1-alpha/2)
    upper = mean_return + std_return * t_crit
    if eigval[end-i+1] < upper
        break
    end
    significant_columns = i
    X1 = X1 - scores * loadings' 
    end
    return significant_columns
end