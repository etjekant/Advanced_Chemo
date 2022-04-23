# Shuffle Non normalized PCA code
x, y, namen = data_reading()
return_data = suffle_PCA(deepcopy(x))
y
# Shuffle Std normalized
x, y, namen = data_reading()
x, y = normalize_data(x, y)
namen, x = remove_shit(x, namen)
return_data_std = suffle_PCA(deepcopy(x))

# Shuffle mean normalized
x, y, namen = data_reading()
x, y = normalize_data(x, y, "mixmax")
namen, x = remove_shit(x, namen)
return_data_mean = suffle_PCA(deepcopy(x))


x, y, namen = data_reading()
x, y1 = normalize_data(x, y, "mixmax")
namen, x = remove_shit(x, namen)
radj_PCA(x, y)


