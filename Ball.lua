--[[
    GD50 2018
    Pong Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.


]]
VIRTUAL_WIDTH=432
VIRTUAL_HEIGHT=243

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-100, 100)
end

--[[
    Places the ball in the middle of the screen, with an initial random velocity
    on both axes.
]]
function Ball:reset(seft)
    self.x = 432 / 2 - 2
    self.y = 243 / 2 - 2
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

--[[
    Simply applies velocity to position, scaled by deltaTime.
]]

function Ball:collides(paddle)
    if self.x>paddle.x+paddle.width or paddle.x>self.x+self.width then
        return false 
    end

    if self.y>paddle.y+paddle.height or paddle.y >self.y+self.height then 
        return false 
    end

    return true 
    -- body
end
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end