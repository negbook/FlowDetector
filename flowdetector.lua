FlowDetector = {}
FlowDetector_Vars = {}
FlowDetector_CallbackInitialise = {}
FlowDetector_CallbackSame = {}
FlowDetector_CallbackChange = {}
FlowDetector_CallbackHash = {}
FlowDetector_LinkTable = {}
debuglog = false
FlowDetector.FlowCheck = function(name,inputValue)
	if debuglog and not FlowDetector_Vars[name] then 
		error("Make Sure FlowCheckCreate('"..name.."') first",2)
        return
	end 
    local FD = FlowDetector_Vars[name]
    local toname = FlowDetector_LinkTable[name]
    if FD then
        local new = FD.temp[2]
        local old = FD.temp[1]
        local refreshFD = function(n) FD.temp[1] = n end
        
        new = inputValue
        if old == nil then 
            if FlowDetector_CallbackInitialise[name] then FlowDetector_CallbackInitialise[name](name,false) end 
            if toname and FlowDetector_CallbackInitialise[toname] then FlowDetector_CallbackInitialise[toname](name,true,toname) end 
            refreshFD(new) 
        elseif old == new or (type(new) == 'table' and json.encode(old) == json.encode(new)) or (type(old) == 'table' and json.encode(old) == json.encode(new)) then 
            if FlowDetector_CallbackSame[name] then FlowDetector_CallbackSame[name](name,false) end 
            if toname and FlowDetector_CallbackSame[toname] then FlowDetector_CallbackSame[toname](name,true,toname) end 
        elseif old ~= new then 
            if new == nil then 
                error("WHY IS HERE GOT NIL?",2)
            else 
                if FlowDetector_CallbackChange[name] then FlowDetector_CallbackChange[name](name,old,new,false) end 
                if toname and FlowDetector_CallbackChange[toname] then FlowDetector_CallbackChange[toname](name,old,new,true,toname) end 
                refreshFD(new) 
            end 
        end 
    end 
    local self = inputValue
    return self
end 
FlowDetector.FlowCheckCreate = function(name,defaultValue,cbchange,cbsame,cbinit)
	if not FlowDetector_Vars[name] then FlowDetector_Vars[name] = {} end 
	FlowDetector_Vars[name].temp = {defaultValue,defaultValue} 
    FlowDetector_CallbackChange[name] = cbchange
    FlowDetector_CallbackSame[name] = cbsame
    FlowDetector_CallbackInitialise[name] = cbinit
    return defaultValue
end 
FlowDetector.FlowCheckDelete = function(name)
    if debuglog then 
        error("You may not see this.Set debuglog to false ",2)
    end 
	FlowDetector_Vars[name] = nil
    FlowDetector_CallbackInitialise[name] = nil
    FlowDetector_CallbackSame[name] = nil
    FlowDetector_CallbackChange[name] = nil
    FlowDetector_CallbackHash[name] = nil
	collectgarbage()
end
FlowDetector.RegisterFlowCallback = function(name,types,cb)
    --local shash = tostring(debug.getinfo(2,'S').source)..'line'..tostring(debug.getinfo(2).currentline)
    if not FlowDetector_CallbackHash[name] then FlowDetector_CallbackHash[name] = {} end 
    if not FlowDetector_CallbackHash[name][types] then FlowDetector_CallbackHash[name][types] = {} end 
    local tst = FlowDetector_CallbackHash[name][types]
    table.insert(tst,cb) 
    local cb_cooked = function(...)
        local pack = {...}
        for tp=1,#(tst) do  --cbs tables
            CreateThread(function() --run those cbs at the same time 
                tst[tp](table.unpack(pack))
            end)
        end 
    end 
    if not FlowDetector_Vars[name] then return error("Make sure FlowCheckCreate('".. name .."') first.",2) end 
    local t = string.lower(types)
    if t == "change" then 
        if not FlowDetector_CallbackChange[name] then FlowDetector_CallbackChange[name] = cb_cooked end 
    elseif t == "same" then  
        if not FlowDetector_CallbackSame[name] then FlowDetector_CallbackSame[name] = cb_cooked end 
    elseif t == "init" or t == "initialise" then  
        if not FlowDetector_CallbackInitialise[name] then FlowDetector_CallbackInitialise[name] = cb_cooked end 
    end 
end 
FlowDetector.FlowMakeLink = function(nameornames,sourcename)
    if type(nameornames) == 'string' then 
        local name = nameornames
        FlowDetector_LinkTable[name] = sourcename
        print('makelink '..name,sourcename)
    elseif type(nameornames) == 'table' then 
       for i=1,#nameornames do 
        local name = nameornames[i]
        FlowDetector_LinkTable[name] = sourcename
        print('makelink '..name,sourcename)
       end 
    else 
        error('FlowMakeLink(string or table , sourcename)',2)
    end 
end

FlowDetector.Create = FlowDetector.FlowCheckCreate
FlowDetector.Delete = FlowDetector.FlowCheckDelete
FlowDetector.Register = FlowDetector.RegisterFlowCallback
FlowDetector.Link = FlowDetector.FlowMakeLink
FlowDetector.Check = FlowDetector.FlowCheck