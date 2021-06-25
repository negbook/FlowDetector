# FlowDetector
FlowDetector utilities for FXServer
![image](https://github.com/negbook/flowdetector/blob/main/preview.png?raw=true)

[DESCRIPTION]  
to create a detector to follow a value's changing , cleaning logic  
for developing easier 
not recommanded to public release scripts with this lib because of perfromance  

[INSTALLATION]  
Set it as a dependency in you fxmanifest.lua
and
```
client_script '@flowdetector/flowdetector.lua'
```
[FUNCTIONS]  
```
FlowDetector.Create(name,defaultValue)        --to create a detector to follow a value's changing
FlowDetector.Delete(name)                     --waste the detector
FlowDetector.Register(name,type,cb(name,old,new,islinked,linkto))        --trigger a function when detect something
FlowDetector.Link(name1,name2)                 --link a detector to another detector.
FlowDetector.Check(name,inputValue)                --input a value into the detector

```

[EXAMPLE]
```


CreateThread(function()
    FlowDetector.Link({"A","B"},"Pause")
    FlowDetector.Create('Pause')
    FlowDetector.Create('A')
    FlowDetector.Create('B')
    FlowDetector.Create('C')
    FlowDetector.Link("C","Pause")
    FlowDetector.Register("Pause",'change',function(name,old,new,islinked,linkto)
        if islinked then 
        print(linkto.." change ",tostring(old),tostring(new) .. 'from '..name)
        end 
    end )
    FlowDetector.Register("A",'change',function(name,old,new,islinked,linkto)
        if not islinked then 
        print(name.." change ",tostring(old),tostring(new) )
        end 
    end )
        FlowDetector.Check("Pause",1)
        IsPause = FlowDetector.Check("A",IsPauseMenuActive())
        FlowDetector.Check("Pause",2)
    while true do
        IsPause = FlowDetector.Check("A",IsPauseMenuActive())
        FlowDetector.Check("B",not IsPauseMenuActive())
        FlowDetector.Check("C",999+math.random())
        Citizen.Wait(332)
    end
end)


```
