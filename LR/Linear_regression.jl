@sk_import datasets: make_regression
@sk_import linear_model: LinearRegression

x, y, namen = data_reading()
x, y1 = normalize_data(x, y, "minmax")
namen, x = remove_shit(x, namen)
# define the model
model = LinearRegression()
# fit the model
model.fit(x, y)
# get importance
importance = model.coef_

# summarize feature importance

plot(importance)