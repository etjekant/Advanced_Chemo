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


