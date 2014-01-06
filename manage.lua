function test()
	for i = 1, 100 do
		print("Testing... "..i)
		sleep(1)
	end
end

tst = coroutine.create(test)
while true do
	coroutine.resume(tst)
	sleep(4)
	coroutine.yield(tst)
	sleep(2)
end
