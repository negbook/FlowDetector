FlowDetector = {}
FlowDetector_Vars = {}
FlowDetector_OnInitialise = {}
FlowDetector_OnSame = {}
FlowDetector_OnChange = {}
FlowDetector_CallbackInitialise = {}
FlowDetector_CallbackSame = {}
FlowDetector_CallbackChange = {}
FlowDetector_CallbackHash = {}
FlowDetector_LinkTable = {}
debuglog = false
function FlowCheck(name,inputValue)
	if debuglog and not FlowDetector_Vars[name] then 
		error("Make Sure FlowCheckCreate('"..name.."') first",2)
        return
	end 
    if FlowDetector_LinkTable[name] then 
        local FD = FlowDetector_Vars[name]
        local toname = FlowDetector_LinkTable[name]
        if FD then
            local new = FD.temp[2]
            local old = FD.temp[1]
            local refreshFD = function(n) FD.temp[1] = n end
            new = inputValue
            if old == nil then 
                if FlowOnInitialise then FlowOnInitialise(name,new) end  --無默認值並由nil首次載入
                if FlowDetector_OnInitialise[name] then FlowDetector_OnInitialise[name](name) end
                if FlowDetector_CallbackInitialise[name] then FlowDetector_CallbackInitialise[name](name) end 
                if FlowOnInitialise then FlowOnInitialise(toname,new) end  --無默認值並由nil首次載入
                if FlowDetector_OnInitialise[toname] then FlowDetector_OnInitialise[toname](toname) end
                if FlowDetector_CallbackInitialise[toname] then FlowDetector_CallbackInitialise[toname](toname,name) end 
               
                refreshFD(new) --由nil賦予新值
            elseif old == new then --一樣
                if FlowOnSame then FlowOnSame(name) end 
                if FlowDetector_OnSame[name] then FlowDetector_OnSame[name](name) end
                if FlowDetector_CallbackSame[name] then FlowDetector_CallbackSame[name](name) end 
                if FlowOnSame then FlowOnSame(toname) end 
                if FlowDetector_OnSame[toname] then FlowDetector_OnSame[toname](toname) end
                if FlowDetector_CallbackSame[toname] then FlowDetector_CallbackSame[toname](toname,name) end 
                
            elseif old ~= new then 
                if new == nil then 
                    error("WHY IS HERE GOT NIL?",2)
                else 
                    if FlowOnChange then FlowOnChange(name,old,new) end  --有變更
                    if FlowDetector_OnChange[name] then FlowDetector_OnChange[name](name,old,new) end
                    if FlowDetector_CallbackChange[name] then FlowDetector_CallbackChange[name](name,old,new) end 
                    if FlowOnChange then FlowOnChange(toname,old,new,name) end  --有變更
                    if FlowDetector_OnChange[toname] then FlowDetector_OnChange[toname](toname,old,new,name) end
                    if FlowDetector_CallbackChange[toname] then FlowDetector_CallbackChange[toname](toname,old,new,name) end 
               
                    refreshFD(new) --舊變新
                end 
            end 
        end 
    else 
        local FD = FlowDetector_Vars[name]
        if FD then
            local new = FD.temp[2]
            local old = FD.temp[1]
            local refreshFD = function(n) FD.temp[1] = n end
            new = inputValue
            if old == nil then 
                if FlowOnInitialise then FlowOnInitialise(name,new) end  --無默認值並由nil首次載入
                if FlowDetector_OnInitialise[name] then FlowDetector_OnInitialise[name](name) end
                if FlowDetector_CallbackInitialise[name] then FlowDetector_CallbackInitialise[name](name) end 
               
                refreshFD(new) --由nil賦予新值
            elseif old == new then --一樣
                if FlowOnSame then FlowOnSame(name) end 
                if FlowDetector_OnSame[name] then FlowDetector_OnSame[name](name) end
                if FlowDetector_CallbackSame[name] then FlowDetector_CallbackSame[name](name) end 
                
            elseif old ~= new then 
                if new == nil then 
                    error("WHY IS HERE GOT NIL?",2)
                else 
                    if FlowOnChange then FlowOnChange(name,old,new) end  --有變更
                    if FlowDetector_OnChange[name] then FlowDetector_OnChange[name](name,old,new) end
                    if FlowDetector_CallbackChange[name] then FlowDetector_CallbackChange[name](name,old,new) end 
               
                    refreshFD(new) --舊變新
                end 
            end 
        end 

    end 
    local self = inputValue
    return self
end 

function FlowCheckCreate(name,defaultValue,cbchange,cbsame,cbinit)
	if not FlowDetector_Vars[name] then FlowDetector_Vars[name] = {} end 
	FlowDetector_Vars[name].temp = {defaultValue,defaultValue} 
    FlowDetector_CallbackChange[name] = cbchange
    FlowDetector_CallbackSame[name] = cbsame
    FlowDetector_CallbackInitialise[name] = cbinit
end 

function FlowCheckDelete(name)
    if debuglog then 
        error("You may not see this.Set debuglog to false ",2)
    end 
	FlowDetector_Vars[name] = nil
    FlowDetector_OnInitialise[name] = nil
    FlowDetector_OnSame[name] = nil
    FlowDetector_OnChange[name] = nil
    FlowDetector_CallbackInitialise[name] = nil
    FlowDetector_CallbackSame[name] = nil
    FlowDetector_CallbackChange[name] = nil
    FlowDetector_CallbackHash[name] = nil
	collectgarbage()
end

function RegisterFlowCallback(name,types,cb)
    local shash = tostring(debug.getinfo(2,'S').source)..'line'..tostring(debug.getinfo(2).currentline)
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

function FlowMakeLink(nameornames,sourcename)
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

--[=[
function FlowOnInitialise(name,thefirstValue)
	
end 

function FlowOnSame(name)
	
end

function FlowOnChange(name,fromValue,toValue)
	
end 
--]=]
