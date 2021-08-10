Flow = {}
Flow._temp_ = {old={},new={}}

Flow.Check = function(fn,...)
	Flow._temp_.new[fn] = json.encode({fn(...)})
	--print(Flow._temp_.new[fn])
	if Flow._temp_.old[fn] ~= Flow._temp_.new[fn] then 
		local t = Flow._temp_.old[fn] and json.decode(Flow._temp_.old[fn]) or nil 
		local t2 = json.decode(Flow._temp_.new[fn])
		if t == nil  then 
			--print("new",t,"to",table.unpack(t2))
			local rtbl = {OnNew=function(fn)return fn(t2)end,OnChange=function()end,OnChangeWhatever=function(fn)fn({},t2)end,OnSame=function()end}
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			return rtbl
		else 
			--print("change",table.unpack(t),"to",table.unpack(t2))
			local rtbl = {OnChange=function(fn)return fn(t,t2) end,OnChangeWhatever=function(fn)return fn(t,t2)end,OnSame=function()end,OnNew=function()end}
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			return rtbl
		end 
	else 
		local t = json.decode(Flow._temp_.new[fn])
		--print("same",table.unpack(t))
		local rtbl = {OnSame=function(fn)return fn(t)end,OnNew=function()end,OnChange=function()end,OnChangeWhatever=function()end}
		return rtbl
	end 
end 

Flow.DeleteCheck = function(fn)
	Flow._temp_.new[fn] = nil 
    Flow._temp_.old[fn] = nil 
	collectgarbage()
end
CreateThread(function()
	while true do Wait(1000)
		--Flow.Check(IsPauseMenuActive).OnChange(function(datas1,datas2) -- OnChange or OnChangeWhatever can be choose only one
			--print("OnChange",table.unpack(datas1),table.unpack(datas2))
		--end)
		Flow.Check(IsPauseMenuActive).OnChangeWhatever(function(datas1,datas2)
			print("OnChangeWhatever",table.unpack(datas1),table.unpack(datas2))
		end)
		Flow.Check(IsPauseMenuActive).OnSame(function(datas)
			print("OnSame",table.unpack(datas))
		end)
		Flow.Check(IsPauseMenuActive).OnSame(function(datas)
			print("OnNew",table.unpack(datas))
		end)
	end 
end)
