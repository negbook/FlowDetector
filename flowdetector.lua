FlowDetector = {}
debuglog = false 
function FlowCheck(name,inputValue)
	if debuglog and not FlowDetector[name] then 
		error("Make Sure FlowCheckCreate('"..name.."') first",2)
        return
	end 
	local FD = FlowDetector[name]
    if FD then
        local new = FD.temp[2]
        local old = FD.temp[1]
        local refreshFD = function(n) FD.temp[1] = n end
        new = inputValue
        if old == nil then 
            FlowOnInitialise(name,new) --無默認值並由nil首次載入
            refreshFD(new) --由nil賦予新值
        elseif old == new then --一樣
            FlowOnSame(name)
        elseif old ~= new then 
            if new == nil then 
                error("WHY IS HERE GOT NIL?",2)
            else 
                FlowOnChange(name,old,new) --有變更
                refreshFD(new) --舊變新
            end 
        end 
    end 
end 

function FlowCheckCreate(name,defaultValue)
	if not FlowDetector[name] then FlowDetector[name] = {} end 
	FlowDetector[name].temp = {defaultValue,defaultValue} 
end 

function FlowCheckDelete(name)
	FlowDetector[name] = nil
	collectgarbage()
end

function FlowOnInitialise(name,thefirstValue)
	
end 

function FlowOnSame(name)
	
end

function FlowOnChange(name,fromValue,toValue)
	
end 