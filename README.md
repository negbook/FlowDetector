# FlowDetector
FlowDetector utilities for FXServer

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
```

[EXAMPLE]
```
FlowCheckCreate('health',"hello")
CreateThread(function()
    
    while true do Wait(1000)
        FlowCheck('coords',GetEntityCoords(PlayerPedId()))
        FlowCheck('health',GetEntityHealth(PlayerPedId()))
    end 
end)
```