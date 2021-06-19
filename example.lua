
function StartExample()

    FlowCheckCreate('health',"hello")
    CreateThread(function()
        
        while true do Wait(1000)
            FlowCheck('coords',GetEntityCoords(PlayerPedId()))
            FlowCheck('health',GetEntityHealth(PlayerPedId()))
        end 
    end)
end 
FlowDetector = {}
debuglog = true
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
    if debuglog then 
        error("You may not see this.Set debuglog to false ",2)
    end 
	FlowDetector[name] = nil
	collectgarbage()
end

function FlowOnInitialise(name,thefirstValue)
	
end 

function FlowOnSame(name)
	
end

function FlowOnChange(name,fromValue,toValue)
	local case = {} --cfx-switchcase by negbook https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua
    local switch = setmetatable({},{__call=function(a,b)case=setmetatable({},{__call=function(a,b)return a[b]end,__index=function(a,c)return c and c==b and setmetatable({},{__call=function(a,d)d()end})or function()end end})return a[b]end,__index=function(a,c)return setmetatable({},{__call=function(a,...)end})end})
    switch(name)(
        case('coords')(function()
            print('Position Updated:from ('..type(fromValue)..') '..tostring(fromValue)..'  to ('..type(toValue)..') '..tostring(toValue))
        end),
        case('health')(function()
            print('Health Updated:from ('..type(fromValue)..') '..tostring(fromValue)..'  to ('..type(toValue)..') '..tostring(toValue))
        end)
    )
end 


StartExample()