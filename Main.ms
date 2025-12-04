clear

import "AutoSafe"
import "Objects"
import "Vec2"
import "merp"
import "Particles"
//import "LogoTransition"

Vec2 = Vec2.Vec2

GFX = display(5)
SPD = display(4)
TXT = display(3)

SCALE = 2

GFX.clear
TXT.clear
SPD.clear

Planets = []

Shape = new {}
Shape.radius = 16
Shape.pos = null
Shape.init = function
	self.pos = new Vec2
end function
Shape.draw = function
	GFX.drawEllipse(
	  self.pos.x - self.radius * 0.5, 
	  self.pos.y - self.radius * 0.5,
	  self.radius, self.radius, "#5555aaaa", 1)
end function

Shape.collidesWith = function(shape)
	return (self.pos.distanceTo(shape.pos) < (self.radius * 0.5 + shape.radius * 0.5))
end function

// Planet
for i in range(5)
	Planet = new Sprite
	Planet.image = file.loadImage("./planet.png")
	Planet.scale = SCALE + rnd * 2
	Planet.x = 150 + rnd * (450 * i)
	Planet.y = 320 + rnd * 1040 - 520
	Planet.shape = new Shape
	Planet.shape.radius = 80 * Planet.scale
	Planet.shape.init
	
	Planet.tint = color.rgb(
	  150 + rnd * 105,
	  150 + rnd * 105,
	  150 + rnd * 105  )
	
	Planet.update = function(dt)
		self.shape.pos.x = self.x
		self.shape.pos.y = self.y
		
	end function
	
	Planets.push Planet
	SPD.sprites.push Planet
end for

// Player Ship
ship = new Sprite
ship.x = 480
ship.y = 320
ship.image = file.loadImage("./ship.png")
ship.scale = SCALE
ship.shape = new Shape
ship.shape.init
ship.shape.radius = 32

ship.vel = new Vec2
ship.speed = 3
ship.forwardSpeed = 3
ship.backwardSpeed = 1
ship.thrust = 0

ship.moveAccel = 3
ship.moveFrict = 1

ship.moveDir = new Vec2
ship.moveDir.x = 1

ship.angle = 0
ship.steer = 2

ship.state = "free"

ship.update = function(dt)
	self.shape.pos.x = self.x
	self.shape.pos.y = self.y
	
	xinp = key.axis("Horizontal")
	yinp = key.axis("Vertical")
	
	// Check collition
	for Planet in Planets
		if Planet == self then return
		
		if self.shape.collidesWith(Planet.shape) then
			if key.pressed("space") then
				self.state = "landed"
				
				a = Planet.shape.pos.angleTo([self.x, self.y])
				self.rotation = a
				
				land = new Vec2
				land.x = Planet.shape.radius * 0.5 + self.shape.radius * 0.5
				land.y = 0
				
				land.rotate(a)
				
				self.x = Planet.x + land.x
				self.y = Planet.y + land.y
				
				self.vel.x = 0
				self.vel.y = 0
			end if
		end if
	end for
	
	
	if self.state == "landed" then
		if yinp > 0 then
			self.state = "free"
		end if
	else
		
		// Rotate ship
		self.rotation -= xinp * self.steer
		
		//******* DEBUG
		if false then
			px = self.x + self.moveDir.x * 64
			py = self.y + self.moveDir.y * 64
			
			GFX.fillEllipse px-4, py-4, 8, 8, "#FFFFFF"
		end if
		//**************
		
		// Movement
		v = new Vec2
		
		if yinp != 0 then
			
			// Change speed
			if yinp > 0 then self.speed = self.forwardSpeed
			if yinp < 0 then self.speed = self.backwardSpeed
			
			// Calculate speed
			self.thrust = merp.lerp(self.thrust, yinp * self.speed, self.moveAccel * dt)
			
			// Rotate velocity
			dif = self.rotation - self.angle
			self.angle = self.rotation
			
			self.moveDir.rotate(dif)
			
			if yinp > 0 then
				if frameCount % 6 == 0 then
					p = new Part
					p.x = self.x - self.moveDir.x * 16
					p.y = self.y - self.moveDir.y * 16
					p.speed = 0
					p.scale = 1
					p.color = color.rgb(255, 120, 80)
					p.randomize = false
					p.init
				end if
			end if
		else
			self.thrust = merp.lerp(self.thrust, 0, self.moveFrict * dt)
		end if
		
		// Apply velocity
		self.vel.x = self.moveDir.x * self.thrust
		self.vel.y = self.moveDir.y * self.thrust
		
		self.x += self.vel.x
		self.y += self.vel.y
	end if
end function

SPD.sprites.push ship

last = time
frameCount = 0
while not key.pressed("escape")
	frameCount += 1
	dt   = time - last
	last = time
	
	GFX.clear
	SPD.scrollX = merp.lerp(SPD.scrollX, ship.x - 480, 5 * dt)
	SPD.scrollY = merp.lerp(SPD.scrollY, ship.y - 320, 5 * dt)
	
	GFX.scrollX = merp.lerp(GFX.scrollX, ship.x - 480, 5 * dt)
	GFX.scrollY = merp.lerp(GFX.scrollY, ship.y - 320, 5 * dt)
	
	for sp in SPD.sprites
		sp.update dt
	end for
	
	yield
end while

key.clear
edit