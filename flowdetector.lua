Flow = {}
Flow._temp_ = {old={},new={}}

Flow.Update = function(fn,...)
	Flow._temp_.new[fn] = json.encode({fn(...)})
	Flow._temp_.old[fn] = Flow._temp_.new[fn]
end

Flow.Check = function(fn,...)
	Flow._temp_.new[fn] = json.encode({fn(...)})
	--print(Flow._temp_.new[fn])
	if Flow._temp_.old[fn] ~= Flow._temp_.new[fn] then 
		local t = Flow._temp_.old[fn] and json.decode(Flow._temp_.old[fn]) or nil 
		local t2 = json.decode(Flow._temp_.new[fn])
		if t == nil  then 
			--print("new",t,"to",table.unpack(t2))
			local rtbl = {OnNew=function(fn)return fn(t2)end,OnChange=function()end,OnChangeWhatever=function(fn)fn({},t2)end,OnSame=function()end,Update=function() Flow._temp_.old[fn] = Flow._temp_.new[fn] end}
			--Flow._temp_.old[fn] = Flow._temp_.new[fn]
			return rtbl
		else 
			--print("change",table.unpack(t),"to",table.unpack(t2))
			local rtbl = {OnChange=function(fn)return fn(t,t2) end,OnChangeWhatever=function(fn)return fn(t,t2)end,OnSame=function()end,OnNew=function()end,Update=function() Flow._temp_.old[fn] = Flow._temp_.new[fn] end}
			--Flow._temp_.old[fn] = Flow._temp_.new[fn]
			return rtbl
		end 
	else 
		local t = json.decode(Flow._temp_.new[fn])
		--print("same",table.unpack(t))
		local rtbl = {OnSame=function(fn)return fn(t)end,OnNew=function()end,OnChange=function()end,OnChangeWhatever=function()end,Update=function() end}
		return rtbl
	end 
end 

Flow.DeleteCheck = function(fn)
	Flow._temp_.new[fn] = nil 
    Flow._temp_.old[fn] = nil 
	collectgarbage()
end



