local Flow = {}

Flow._temp_ = {old={},new={},oldDataSource={},newDataSource={}}

Flow.Check = function(fn,...)
	local args = {...} 
	local lastarg = args[#args]
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	local _fn = fn 
	local tt = {_fn(table.unpack(args))}
	Flow._temp_.new[fn] = json.encode(tt)
	Flow._temp_.newDataSource[fn] = tt
	if Flow._temp_.old[fn] ~= Flow._temp_.new[fn] then 
		local t = Flow._temp_.oldDataSource[fn] and Flow._temp_.oldDataSource[fn] or nil 
		local t2 = Flow._temp_.newDataSource[fn]
		if t == nil  then 
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]
			
			if cb then cb("OnInit",t2) end 
			if cb then cb("OnChangeWhatever","nil",t2) end 
		else 
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]

			if cb then cb("OnChange",table.unpack(t),table.unpack(t2)) end 
			if cb then cb("OnChangeWhatever",table.unpack(t),table.unpack(t2)) end 
		end 
	else 
		local t = Flow._temp_.newDataSource[fn]
		if cb then cb("OnSame",table.unpack(t)) end 
	end 
end 

Flow.CheckChange = function(fn,...)
	local args = {...} 
	local lastarg = args[#args]
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	local _fn = fn 
	local tt = {_fn(table.unpack(args))}
	Flow._temp_.new[fn] = json.encode(tt)
	Flow._temp_.newDataSource[fn] = tt
	if Flow._temp_.old[fn] ~= Flow._temp_.new[fn] then 
		local t = Flow._temp_.oldDataSource[fn] and Flow._temp_.oldDataSource[fn] or nil 
		local t2 = Flow._temp_.newDataSource[fn]
		if t == nil  then 
			--print("init",t,"to",table.unpack(t2))
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]
			if cb then cb("nil",t2) end 
		else 
			--print("change",table.unpack(t),"to",table.unpack(t2))
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			Flow._temp_.oldDataSource[fn] = Flow._temp_.newDataSource[fn]
			if cb then cb(table.unpack(t),table.unpack(t2)) end 
		end 
	end 
end 

Flow.CheckSame = function(fn,...)
	local args = {...} 
	local lastarg = args[#args]
	local cb = type(lastarg) == "function" and lastarg or nil
	table.remove(args,#args)
	local _fn = fn 
	local tt = {_fn(table.unpack(args))}
	Flow._temp_.new[fn] = json.encode(tt)
	Flow._temp_.newDataSource[fn] = tt
	if Flow._temp_.old[fn] == Flow._temp_.new[fn] then 
		local t = Flow._temp_.newDataSource[fn]
		--print("same",table.unpack(t))
		if Flow._temp_.cbsame[fn] then Flow._temp_.cbsame[fn](t) end 
		if cb then cb(table.unpack(t)) end 
	end 
end 


Flow.DeleteCheck = function(fn)
	Flow._temp_.new[fn] = nil 
    Flow._temp_.old[fn] = nil 
end


