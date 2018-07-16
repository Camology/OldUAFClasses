local pa2 = {}

function pa2.mapArray(funk, arr)
	for key,val in ipairs(arr) do
		arr[key] = funk(val)
	end
	return arr
end


function pa2.concatMax(s,i)
	return s:rep(math.floor(i/s:len()))
end


function pa2.collatz(k)
	local returns = { k }
	while k ~= 1 do
		if k % 2 ==0 then
			k = k/2
		else
			k = 3*k + 1
		end
		table.insert(returns, k)
	end

	for key, value in ipairs(returns) do 
		coroutine.yield(returns[key])
	end
end
return pa2