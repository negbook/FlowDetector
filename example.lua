
CreateThread(function()
	while true do Wait(1000)
		Flow.Check(IsPauseMenuActive).OnChange(function(datas1,datas2) 
			print("OnChange",table.unpack(datas1),table.unpack(datas2))
		end)
		Flow.Check(IsPauseMenuActive).OnChangeWhatever(function(datas1,datas2)
			print("OnChangeWhatever",table.unpack(datas1),table.unpack(datas2))
		end)
		Flow.Check(IsPauseMenuActive).OnSame(function(datas)
			print("OnSame",table.unpack(datas))
		end)
		Flow.Check(IsPauseMenuActive).OnSame(function(datas)
			print("OnNew",table.unpack(datas))
		end)
		Flow.Check(IsPauseMenuActive).Update() -- or Flow.Update(IsPauseMenuActive)
		
	end 
end)