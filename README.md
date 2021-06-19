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


FlowOnInitialise(name,thefirstValue)      --when the value is from undefined to a value 
FlowOnSame(name)                          --when the newervalue is the same from oldervalue
FlowOnChange(name,fromValue,toValue)      --when the value become a new value 
```