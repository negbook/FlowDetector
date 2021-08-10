local Flow = {}
--com.lua.utils.Flow = Flow
Flow._temp_ = {}
Flow._temp_.old={}
Flow._temp_.new={}
Flow._temp_.on={}
Flow._temp_.cbchange={}
Flow._temp_.cbsame={}
Flow._temp_.cboninit={}

Flow.CreateCallback = function(fn,cbOnChange,cbOnSame,cbOnInit)
	if cbOnChange then Flow._temp_.cbchange[fn] = cbOnChange end 
	if cbOnSame then Flow._temp_.cbsame[fn] = cbOnSame end 
	if cbOnInit then Flow._temp_.cboninit[fn] = cbOnInit end 
end 


Flow.CreateCallbackOnChange = function(fn,cbOnChange)
	if cbOnChange then Flow._temp_.cbchange[fn] = cbOnChange end 
end 

Flow.CreateCallbackOnSame = function(fn,cbOnSame)
	if cbOnSame then Flow._temp_.cbsame[fn] = cbOnSame end 
end 

Flow.CreateCallbackOnInit = function(fn,cbOnInit)
	if cbOnInit then Flow._temp_.cboninit[fn] = cbOnInit end 
end 

Flow.Check = function(fn,...)
	local _fn = fn 
	--if type(fn) == 'table' then --remote functions
		--if fn.__cfx_functionReference then 
			--fn = com.lua.utils.Text.Split(fn.__cfx_functionReference,":")[1]..tostring(com.lua.utils.Text.Split(fn.__cfx_functionReference,":")[2])
		--end 
	--end 
	local tt = {_fn(...)}
	Flow._temp_.new[fn] = json.encode(tt)
	if Flow._temp_.old[fn] ~= Flow._temp_.new[fn] then 
		local t = Flow._temp_.old[fn] and json.decode(Flow._temp_.old[fn]) or nil 
		local t2 = json.decode(Flow._temp_.new[fn])
		if t == nil  then 
			print("init",t,"to",table.unpack(t2))
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			if Flow._temp_.cbchange[fn] then Flow._temp_.cbchange[fn](t,t2,true) end 
		else 
			print("change",table.unpack(t),"to",table.unpack(t2))
			Flow._temp_.old[fn] = Flow._temp_.new[fn]
			if Flow._temp_.cbchange[fn] then Flow._temp_.cbchange[fn](t,t2,false) end 
		end 
	else 
		local t = json.decode(Flow._temp_.new[fn])
		print("same",table.unpack(t))
		if Flow._temp_.cbsame[fn] then Flow._temp_.cbsame[fn](t) end 
	end 
end 

Flow.DeleteCheck = function(fn)
	Flow._temp_.new[fn] = nil 
    Flow._temp_.old[fn] = nil 

end


