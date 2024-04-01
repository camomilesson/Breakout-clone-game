Button = Entity:extend()

function Button:new(x, y, text)
  Button.super.new(self, x, y)
  self.text = text
  self.textWidth = font:getWidth(self.text)
  self.textHeight = font:getHeight()
  self.width = self.textWidth + 15
  self.height = self.textHeight + 15
end

function Button:update(dt)

end

function Button:draw()
  love.graphics.rectangle("fill", self.x - self.width / 2 - 1, self.y - self.height / 2, self.width + 2, self.height)
  love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2 - 1, self.width, self.height + 2)
  love.graphics.setColor(palette[5])
  love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(self.text, self.x - self.width / 2, self.y - self.textHeight / 2, self.width, "center")
end
