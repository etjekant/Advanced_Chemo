#Project Toxicity  (HCA)

function remove_shit(x_data, namen=[])
    # This function takes a Dataframe or Matrix as input. 
    # When a DataFrame is given "namen" can be left empty. When a 
    # Matrix is given, namen should be specified. This makes sure the column headers
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
    return namen, x_data
end

function calcDist(data)

	dist = zeros(size(data,1),size(data,1))
	for i = 1:size(data,1)-1
		for j = i+1:size(data,1)
			dist[j,i] = data[j,1] - data[i,1]
		end
	end

	dist += dist'
	# set diagonal
	dist[diagind(dist)] .= Inf
	return abs.(dist)
end

function clustering(data)
	data = sort(data)
	cl = [Int.(ones(size(data,1), size(data,1)) .* collect(1:size(data,1))) data]
	cl_means = Array{Union{Missing, Vector{Float64}}}(missing, size(data,1), 1)
	data = [data collect(1:length(data))]

	for i = 1:size(cl,1)-1
		cl_means[i] = data[:,1]
		dist = calcDist(data)
		ind = findmin(dist)[2]
		#merge values
		ind_add = findall(cl[:,i] .== data[ind[1],2])
		cl[ind_add,i+1:end-1] .= data[ind[2],2]
		#adjust data
		data = data[1:end .!= ind[1],:]  	#remove row
		#calculate new cluster mean
		data[ind[2],1] = mean(cl[findall(cl[:,i+1] .== data[ind[2],2]),end])
	end
	cl_means[size(cl,1)] = [mean(cl[:,end])]

	return cl, cl_means
end

function HCLplot(cl,cl_means)
	plot()
	for i = 1:size(cl,1)
		println(i)
		# scatter!(cl[:,end],
		# 		 ones(size(cl,1)).*(i-1),c = 1,label = false)
		#plot upward lines
		plot!([cl_means[i]'; cl_means[i]'],
			  [(ones(size(cl,1)).*(i-1))';(ones(size(cl,1)).*i)'],
			  c = 1,label = false)
		#plot horz. line
		ind_change = findall(cl[:,i] .!= cl[:,i+1])[1]
		ind = findall(cl[:,i+1] .== cl[ind_change,i+1])
		plot!(cl_means[i][ind], [1; 1] .* i,
			  c = 1, label = false)
		#adjust cl for next plot
		cl = cl[1:end .!= ind_change,:]
	end
	return plot!()
end

## Expand calcDist function for multiple variables
function calcDistMultipleFeatures(data)
	# each row is considered a sample and the columns are features
	dist = zeros(size(data,1),size(data,1))
	for i = 1:size(data,1)-1
		for j = i+1:size(data,1)
			dist[j,i] = sqrt(sum((data[i,:] .- data[j,:]).^2))
		end
	end

	return dist += dist'
end

data = CSV.read("/Users/ikram/Documents/Master/March-May 2022/Advanced Chemometrics and Statistics/Project /toxicity_data_fish_desc.csv", DataFrame)
descr = describe(data)

x = data[:, 8:end]
namen, x = remove_shit(x);
x = Matrix(x)
namen = namen

#Calculate Distance Matrix
DM = calcDistMultipleFeatures(x)

#perform clustering
comp = hclust(DM, linkage=:complete)
aver = hclust(DM, linkage=:average)

plot(	plot(comp, xlabel="complete"),
		plot(aver, xlabel="average"))

