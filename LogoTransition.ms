
Start = function
	clear
	
	// If you add an image to the ./Logos folder add a number to the amountOfLogos variable
	amountOfLogos = 1
	
	// Change this value to control the speed of the transition
	transitionSpeed = 2.5
	
	// Change the scale at wich the logos are displayed
	scale = 1
	
	// Change the background color
	bgColor = color.rgba(10,10,10)
	
	// DO NOT EDIT AFTER THIS
	
	logos = []
	
	for i in range(0, amountOfLogos)
		logos.push file.loadImage("./Logos/" + i + ".png")
	end for
	
	cl = new Sprite
	cl.image = logos[0]
	cl.x = 480; cl.y = 320
	cl.scale = scale
	
	
	current = 0
	curAlpha = 0
	dir = 1
	
	display(4).sprites.push cl
	gfx.clear bgColor, 960, 640
	
	run = true
	while run
		if curAlpha == 0 and current >= amountOfLogos then
			run = false
			break
		end if
		
		cl.tint = color.rgba(255, 255, 255, curAlpha)
		
		curAlpha += transitionSpeed * dir
		
		if dir == 1 and curAlpha >= 255 then
			dir = -1
		else if dir == -1 and curAlpha <= 0 then
			current += 1
			cl.image = logos[current]
			dir = 1
		end if
		
		yield
	end while
end function

Start