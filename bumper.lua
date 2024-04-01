Bumper = Entity:extend()

function Bumper:new(x, y)
  Bumper.super.new(self, x, y)
  self.speed = 300
  self.width = 100
  self.height = 10
end

function Bumper:update(dt)
  if love.keyboard.isDown("left") then
    self.x = self.x - self.speed * dt
    ball_start()
  elseif love.keyboard.isDown("right") then
    self.x = self.x + self.speed * dt
    ball_start()
  elseif love.keyboard.isDown("space") then
    ball_start()
  end
end

function Bumper:draw()
  love.graphics.draw(brick_images[1], self.x, self.y, 0, self.width / brick_images[1]:getWidth(), self.height / brick_images[1]:getHeight())
end
