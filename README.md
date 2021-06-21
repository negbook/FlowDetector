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
RegisterFlowCallback(name,type,cb(name,old,new,islinked/fromlinkedname))        --trigger a function when detect something
FlowMakeLink(name1,name2)                 --link a detector to another detector.

```

[EXAMPLE]
```

CreateThread(function()
    FlowMakeLink({"A","B"},"Pause")
    FlowCheckCreate('Pause')
    FlowCheckCreate('A')
    FlowCheckCreate('B')
    FlowCheckCreate('C')
    FlowMakeLink("C","Pause")
    RegisterFlowCallback("Pause",'change',function(name,old,new,linkedname)
        linkedname = linkedname or 'self'
        print(name.." change ",tostring(old),tostring(new) .. 'from '..linkedname)
    end )
    RegisterFlowCallback("A",'change',function(name,old,new,linkedname)
        linkedname = linkedname or 'self'
        print(name.." change ",tostring(old),tostring(new) .. 'from '..linkedname)
    end )
        FlowCheck("Pause",1)
        IsPause = FlowCheck("A",IsPauseMenuActive())
        FlowCheck("Pause",2)
    while true do
        IsPause = FlowCheck("A",IsPauseMenuActive())
        FlowCheck("B",not IsPauseMenuActive())
        FlowCheck("C",999+math.random())
        Citizen.Wait(332)
    end
end)


```
