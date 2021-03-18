require 'dxruby'

class Toufu < Sprite
  @@image = Image.new(50,50,[150,150,150])

  def initialize
    super
    self.x = rand(590)
    self.y = rand(430)
    @dx = rand(2) * 2 - 1
    @dy = rand(2) * 2 - 1
    self.image = @@image
  end

  def update
    self.x += @dx
    self.y += @dy
    @dx = -@dx if self.x < 0 or self.x > 590
    @dy = -@dy if self.y < 0 or self.y > 430
  end

  def hit(obj)
    if (self.x - obj.x).abs < (self.y - obj.y).abs
      @dy = -@dy
    else
      @dx = -@dx
    end
  end
end

s = Array.new(10) { Toufu.new }

Window.loop do
  Sprite.update(s)
  Sprite.check(s)
  Sprite.draw(s)

  break if Input.keyPush?(K_ESCAPE)
end
