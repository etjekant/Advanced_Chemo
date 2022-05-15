
# Shuffle Std normalized
x, y, namen = data_reading()
x, y = normalize_data(x, y)
namen, x = remove_shit(x, namen)
return_data_std = suffle_PCA(deepcopy(x))
x1 = x[:,1781:1788]
@sk_import model_selection: train_test_split
@sk_import pipeline: make_pipeline
@sk_import linear_model: LinearRegression
@sk_import preprocessing: StandardScaler
@sk_import decomposition: PCA
@sk_import cross_decomposition: PLSRegression

X_train, X_test, y_train, y_test = train_test_split(x1, y,test_size = 0.3, random_state=42)

pcr = make_pipeline(StandardScaler(), PCA(n_components=1), LinearRegression())
pcr.fit(X_train, y_train)
pca = pcr.named_steps["pca"]  # retrieve the PCA step of the pipeline

scatter(pca.transform(X_test), y_test, alpha=0.5, label="ground truth")
scatter!(
    pca.transform(X_test), pcr.predict(X_test), alpha=0.5, label="predictions", 
    xlabel="Projected data onto first PCA component", ylabel="y", title="PCR"
)

