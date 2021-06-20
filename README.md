# FlowDetector
FlowDetector utilities for FXServer
![image](https://github.com/negbook/flowdetector/blob/main/preview.png?raw=true)

[DESCRIPTION]  
to create a detector to follow a value's changing  

[INSTALLATION]  
Set it as a dependency in you fxmanifest.lua
and
```
client_script '@flowdetector/flowdetector.lua'
```
[FUNCTIONS]  
```
FlowCheckCreate(name,defaultValue)        --to create a detector to follow a value's changing
FlowCheck(name,inputValue)                --input a value into the detector


FlowCheckDelete(name)                     --waste the detector


FlowOnInitialise(name,thefirstValue)      --when the value is from undefined to a newervalue 
FlowOnSame(name)                          --when the newervalue is the same from oldervalue
FlowOnChange(name,fromValue,toValue)      --when the oldervalue become a new value 

FlowDetector.OnInitialise[name](name,thefirstValue) --same as above but example2.lua
FlowDetector.OnSame[name](name,thefirstValue)  --same  as above but example2.lua
FlowDetector.OnChange[name](name,thefirstValue)  --same  as above but example2.lua
```

[EXAMPLE] [cfx-switchcase by negbook](https://github.com/negbook/cfx-switchcase/blob/main/cfx-switchcase.lua)
```
function FlowOnChange(name,fromValue,toValue)
	local case = {} --cfx-switchcase by negbook 
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
FlowCheckCreate('health',"hello")
CreateThread(function()
    
    while true do Wait(1000)
        FlowCheck('coords',GetEntityCoords(PlayerPedId()))
        FlowCheck('health',GetEntityHealth(PlayerPedId()))
    end 
end)
```

[EXAMPLE2]
```
FlowDetector.OnChange["Pause"] = function(name,old,new)
    if old == false then 
        print(name,"Turning On Pause")
    else 
        print(name,"Turning Off Pause")
    end 
end 

CreateThread(function()
    FlowCheckCreate("Pause")
    while true do
        FlowCheck("Pause",IsPauseMenuActive())
        Citizen.Wait(332)
    end
end)
```

[EXAMPLE3]
```
CreateThread(function()
    FlowCheckCreate("Pause",false,function(name,old,new)
        print(name.." change")
    end )
    while true do
        IsPause = FlowCheck("Pause",IsPauseMenuActive())
        Citizen.Wait(332)
    end
end)
```

[EXAMPLE4]
```

CreateThread(function()
    FlowCheckCreate('Pause',false)
    RegisterFlowCallback("Pause",'change',function(name,old,new)
        print(name.."hi")
    end )
    RegisterFlowCallback("Pause",'same',function(name,old,new)
        print(name.."xD")
    end )
    while true do
        IsPause = FlowCheck("Pause",IsPauseMenuActive())
        Citizen.Wait(332)
    end
end)
```
