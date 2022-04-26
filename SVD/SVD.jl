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

