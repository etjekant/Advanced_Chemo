# Shuffle PCA code
data = CSV.read(path*"toxicity_data_fish_desc.csv", DataFrame)
# Making the x_values
x = data[:, 8:end];
namen, x = remove_shit(x);
x = Matrix(x)[:, end-50:end];
namen = namen[end-50:end];
# normalizing the data
X1 = (x .- mean(x,dims = 1)) ./ (maximum(x, dims=1)-minimum(x, dims=1));
namen, X1 = remove_shit(X1, namen);
# Prepare the y_values
y = data[:, 6];
# Calculating the eigenvalues, they are used to compare
# if the values are significant

cov_m = cov(X1);
eigval = eigvals(cov_m);
eigvec =  eigvecs(cov_m);
loadings = eigvec;


