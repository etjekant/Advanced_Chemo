function data_reading(;clean=true, mono_mass=false)
    # This function reads the data and cleans the data if you want to. Also the first columns are removed
    # These are the columns that are not important
    data = CSV.read("./toxicity_data_fish_desc.csv", DataFrame)
    x = data[:, 8:end]
    y = data[:, 6]
    namen = names(x)
    if clean
        x, namen= remove_shit(x, namen)
    end
    if mono_mass
        return  Matrix(x), y, namen, data[:, 7]
    end
    return Matrix(x), y, namen
end

function r_cal(x2, y, y_hat)
    # r_cal takes as input three vectors of the same length. 
    SSr = sum((y - y_hat).^2)
    SSe = sum((y_hat .- mean(y)).^2)
    SSt = sum((y .- mean(y)).^2)
    Rsquared = 1 - (SSr/SSt)
    columns = 0
    try
        columns = size(x2)[2]
    catch BoundsError
        columns = 1
    end
    VARres = SSr/(length(y)-columns)         # calculating VARres
    VARtot = SSt/(length(x2)-1)                  # calculating VARtot
    rsqadj = 1 - (VARres/VARtot)
    return Rsquared, rsqadj
end

function remove_shit(x_data, namen=[])
    # This function takes a Dataframe or Matrix as input. 
    # When a DataFrame is given "namen" can be left empty. When a 
    # Matrix is given, namen should be spicified. This makes sure the column headers
    # are known when working with the data. 
    if isempty(namen)
        namen = names(x_data)
    end
    namen = namen[vec(.!any(ismissing.(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any(ismissing.(Matrix(x_data)), dims=1))]
    namen = namen[vec(.!any(isnan.(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any(isnan.(Matrix(x_data)), dims=1))]
    namen = namen[vec(.!any(Inf.==(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any(Inf.==(Matrix(x_data)), dims=1))]
    namen = namen[vec(.!any((-Inf).==(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any((-Inf).==(Matrix(x_data)), dims=1))]
    return x_data, namen
end
                                                
function distance_calc(N)
    # This function calculates the distance for the one-dementional data. the input is a vector of data. 
    dist = zeros(size(N, 1), size(N, 1))
    for i = 1:size(N, 1)-1
        for j = i + 1:size(N,1)
            dist[j,i] = mean(N[j]) - mean(N[i])
        end
    end
    dist += dist'
    return abs.(dist)
end

function distance_calc_higher(data)
    # This function calculates the distance for higher order datasets. can be used with any shape. 
    dist = zeros(size(data, 1), size(data, 1))
    for i = 1:size(data, 1)-1
        for j = i + 1:size(data,1)
            dist[j,i] = sqrt(sum((data[i, :] .- data[j, :]).^2))
        end
    end
    return dist += dist'
end                                                              

function normalize_data(x, y, method="std")
    if method == "std"
        x = (x .- mean(x, dims=1)) ./ std(x, dims = 1)
        y = (y .- mean(y)) / std(y)
    elseif method == "minmax"
        x = (x .- maximum(x, dims=1)) ./ (maximum(x, dims=1) - minimum(x, dims=1))
        y = (y .- maximum(x)) ./ (maximum(x) - minimum(x))
    end
    return x, y
end


