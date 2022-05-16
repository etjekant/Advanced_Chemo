# Shuffle Non normalized PCA code
x, y, namen = data_reading()
return_data = suffle_PCA(deepcopy(x))
X1 = x

"""
Row │ Column_number  upper       eigenvalue 
│ Int64          Float64     Float64    
─────┼───────────────────────────────────────
1 │          2300  2.70251e12  2.7066e12
2 │          2299  5.11878e12  2.46163e12
"""

# Shuffle Std normalized
x, y, namen = data_reading()
x, y = normalize_data(x, y)
x, namen = remove_shit(x, namen)
return_data_std = suffle_PCA(deepcopy(x))

# laatste 7 colomen
"""
Row │ Column_number  upper     eigenvalue 
│ Int64          Float64   Float64    
─────┼─────────────────────────────────────
1 │          1788   5.92224    277.188
2 │          1787  11.5118     121.16
3 │          1786  17.0469      73.0586
4 │          1785  22.6109      69.8361
5 │          1784  28.0         48.0812
6 │          1783  33.4569      44.1166
7 │          1782  38.7162      41.499
8 │          1781  44.0397      39.1123
"""

# Shuffle mean normalized
x, y, namen = data_reading()
x, y = normalize_data(x, y, "mixmax")
x, namen = remove_shit(x, namen)
return_data_mean = suffle_PCA(deepcopy(x))
"""
Row │ Column_number  upper       eigenvalue 
     │ Int64          Float64     Float64    
─────┼───────────────────────────────────────
   1 │          2300  2.73314e12  1.50355e13
   2 │          2299  5.19126e12  1.63529e12
"""