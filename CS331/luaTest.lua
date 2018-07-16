--animal mod implemented

animal = require "luaMod" --must be name of the lua file

animal.howdy()

cat = animal.beast.new() 
setmetatable(cat, animal.beast)
cat:stomp()
cat:setSound("meow")
cat:makeSound()

function make_multiple(k)
	function mult(x)
		return k*x
	end
	return mult
end

triple = make_multiple(3)
times100 = make_multiple(100)
times2point5 = make_multiple(2.5)
io.write(" 3 * 7 = " .. triple(7) .. "\n")
io.write(" 2.5 * 1 = " ..times2point5(1) .. "\n")
io.write(" 2 * 100 = " ..times100(2) .. "\n")
