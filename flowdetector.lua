FlowDetector = {}
FlowDetector_Vars = {}

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
            refreshFD(new) --由nil賦予新值
        elseif old == new then --一樣
            if FlowOnSame then FlowOnSame(name) end 
        elseif old ~= new then 
            if new == nil then 
                error("WHY IS HERE GOT NIL?",2)
            else 
                if FlowOnChange then FlowOnChange(name,old,new) end  --有變更
                refreshFD(new) --舊變新
            end 
        end 
    end 
end 

function FlowCheckCreate(name,defaultValue)
	if not FlowDetector_Vars[name] then FlowDetector_Vars[name] = {} end 
	FlowDetector_Vars[name].temp = {defaultValue,defaultValue} 
end 

function FlowCheckDelete(name)
    if debuglog then 
        error("You may not see this.Set debuglog to false ",2)
    end 
	FlowDetector_Vars[name] = nil
	collectgarbage()
end

--[=[
function FlowOnInitialise(name,thefirstValue)
	
end 

function FlowOnSame(name)
	
end

function FlowOnChange(name,fromValue,toValue)
	
end 
--]=]