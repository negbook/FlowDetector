FlowDetector = {}
FlowDetector_Vars = {}
FlowDetector.OnInitialise = {}
FlowDetector.OnSame = {}
FlowDetector.OnChange = {}
FlowDetector.CallbackInitialise = {}
FlowDetector.CallbackSame = {}
FlowDetector.CallbackChange = {}
FlowDetector_CallbackHash = {}

debuglog = false
function FlowCheck(name,inputValue)
	if debuglog and not FlowDetector_Vars[name] then 
		error("Make Sure FlowCheckCreate('"..name.."') first",2)
        return
	end 
	local FD = FlowDetector_Vars[name]
    if FD then
        local new = FD.temp[2]
        local old = FD.temp[1]
        local refreshFD = function(n) FD.temp[1] = n end
        new = inputValue
        if old == nil then 
            if FlowOnInitialise then FlowOnInitialise(name,new) end  --無默認值並由nil首次載入
            if FlowDetector.OnInitialise[name] then FlowDetector.OnInitialise[name](name) end
            if FlowDetector.CallbackInitialise[name] then FlowDetector.CallbackInitialise[name](name,old,new) end 
            refreshFD(new) --由nil賦予新值
        elseif old == new then --一樣
            if FlowOnSame then FlowOnSame(name) end 
            if FlowDetector.OnSame[name] then FlowDetector.OnSame[name](name) end
            if FlowDetector.CallbackSame[name] then FlowDetector.CallbackSame[name](name,old,new) end 
        elseif old ~= new then 
            if new == nil then 
                error("WHY IS HERE GOT NIL?",2)
            else 
                if FlowOnChange then FlowOnChange(name,old,new) end  --有變更
                if FlowDetector.OnChange[name] then FlowDetector.OnChange[name](name,old,new) end
                if FlowDetector.CallbackChange[name] then FlowDetector.CallbackChange[name](name,old,new) end 
                refreshFD(new) --舊變新
            end 
        end 
    end 
    local self = inputValue
    return self
end 

function FlowCheckCreate(name,defaultValue,cbchange,cbsame,cbinit)
	if not FlowDetector_Vars[name] then FlowDetector_Vars[name] = {} end 
	FlowDetector_Vars[name].temp = {defaultValue,defaultValue} 
    FlowDetector.CallbackChange[name] = cbchange
    FlowDetector.CallbackSame[name] = cbsame
    FlowDetector.CallbackInitialise[name] = cbinit
end 

function FlowCheckDelete(name)
    if debuglog then 
        error("You may not see this.Set debuglog to false ",2)
    end 
	FlowDetector_Vars[name] = nil
	collectgarbage()
end

function RegisterFlowCallback(name,types,cb)
    local shash = GetHashKey(tostring(debug.getinfo(2,'f'))..tostring(debug.getinfo(2).currentline))
    if not FlowDetector_CallbackHash[types] then FlowDetector_CallbackHash[types] = {} end 
    if not FlowDetector_CallbackHash[types][shash] then FlowDetector_CallbackHash[types][shash] = {} end 
    FlowDetector_CallbackHash[types][shash].cb = cb 
    FlowDetector_CallbackHash[types][shash].name = name 
    local _cb = function(...)
        for i,v in pairs(FlowDetector_CallbackHash[types]) do 
            v.cb(...)
        end 
    end 
    if not FlowDetector_Vars[name] then return error("Make sure FlowCheckCreate('".. name .."') first.",2) end 
    local t = string.lower(types)
    if t == "change" then 
    FlowDetector_CallbackChange[name] = _cb
    elseif t == "same" then  
    FlowDetector_CallbackSame[name] = _cb
    elseif t == "init" or t == "initialise" then  
    FlowDetector_CallbackInitialise[name] = _cb
    end 
end 

--[=[
function FlowOnInitialise(name,thefirstValue)
	
end 

function FlowOnSame(name)
	
end

function FlowOnChange(name,fromValue,toValue)
	
end 
--]=]
