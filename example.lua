CreateThread(function()
	while true do Wait(1000)
		Flow.Check(IsPauseMenuActive).OnChangeWhatever(function(data1,data2)
			print("OnChangeWhatever",table.unpack(data1),table.unpack(data2))
		end)

	end 
end)
