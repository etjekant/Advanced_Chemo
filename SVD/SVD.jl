# std normalized SVD
x, y, namen = data_reading();
x, y = normalize_data(x, y, "std");
x, namen = remove_shit(x, namen);
var_exp_std = sort(var_exp_svd(x));

# range normalized SVD
x, y, namen = data_reading();
x, y = normalize_data(x, y, "minmax");
x, namen = remove_shit(x, namen);
var_exp_mean = sort(var_exp_svd(x));

# Non normalized SVD
x, y, namen = data_reading();
x, namen = remove_shit(x, namen);
var_exp_non = sort(var_exp_svd(x));

var_exp_std = Matrix(CSV.read("./results/var_exp_std.csv", DataFrame))
var_exp_mean = Matrix(CSV.read("./results/var_exp_mean.csv", DataFrame))
var_exp_non = Matrix(CSV.read("./results/var_exp_non.csv", DataFrame))
normalized_x = 1:(2300/length(var_exp_std)):2300; 
plot(normalized_x, cumsum(vec(var_exp_std)))
normalized_x = 1:(2300/length(var_exp_mean)):2300; 
plot!(normalized_x, cumsum(vec(var_exp_mean)))
normalized_x = 1:(2300/length(var_exp_non)):2300; 
plot!(normalized_x, cumsum(var_exp_non))


data = CSV.read("Rel_res.csv", DataFrame)
plot(data[:, 2], seriestype=:scatter)

