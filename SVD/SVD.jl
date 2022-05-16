# std normalized SVD
PLSSVD
x, y, namen = data_reading();
x, y = normalize_data(x, y, "std");
scatter(sort(y))
x, namen = remove_shit(x, namen);
var_exp_std = var_exp_svd(x)
CSV.write("./results/var_exp_std.csv", DataFrame(var_exp_std', namen))

# range normalized SVD
x, y, namen2 = data_reading();
x, y = normalize_data(x, y, "minmax");
x, namen2 = remove_shit(x, namen2);
var_exp_mean = sort(var_exp_svd(x));
CSV.write("./results/var_exp_mean.csv", DataFrame(var_exp_mean', namen2))

# Non normalized SVD
x, y, namen3 = data_reading();
x, namen3 = remove_shit(x, namen3);
var_exp_non = sort(var_exp_svd(x));
CSV.write("./results/var_exp_non.csv", DataFrame(var_exp_non', namen3))

var_exp_std = Matrix(CSV.read("./results/var_exp_std.csv", DataFrame))
var_exp_mean = Matrix(CSV.read("./results/var_exp_mean.csv", DataFrame))
var_exp_non = Matrix(CSV.read("./results/var_exp_non.csv", DataFrame))
normalized_x = 1:(2300/length(var_exp_std)):2300; 
plot(cumsum(vec(var_exp_std)))
normalized_x = 1:(2300/length(var_exp_mean)):2300; 
plot!(normalized_x, cumsum(vec(var_exp_mean)))
normalized_x = 1:(2300/length(var_exp_non)):2300; 
plot!(normalized_x, cumsum(var_exp_non))


data = CSV.read("Rel_res.csv", DataFrame)
plot(data[:, 2], seriestype=:scatter)




