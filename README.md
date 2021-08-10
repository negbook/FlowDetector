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
Flow.Check(fn,...)
Flow.DeleteCheck(fn)

```

[EXAMPLE]
```

CreateThread(function()
	while true do Wait(1000)
		--Flow.Check(IsPauseMenuActive).OnChange(function(datas1,datas2)  OnChange or OnChangeWhatever can be choose only one
			--print("OnChange",table.unpack(datas1),table.unpack(datas2))
		--end)
		Flow.Check(IsPauseMenuActive).OnChangeWhatever(function(datas1,datas2)
			print("OnChangeWhatever",table.unpack(datas1),table.unpack(datas2))
		end)
		Flow.Check(IsPauseMenuActive).OnSame(function(datas)
			print("OnSame",table.unpack(datas))
		end)
		Flow.Check(IsPauseMenuActive).OnSame(function(datas)
			print("OnNew",table.unpack(datas))
		end)
	end 
end)


```
