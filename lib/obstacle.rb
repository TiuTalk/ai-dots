class Obstacle
  def initialize
    @width = rand(40..200)
    @height = 10
    @x = rand(10..Game::WIDTH) - @width
    @y = rand(10..Game::HEIGHT*0.7) - @height
    @color = Gosu::Color.new(255, rand(255), rand(255), rand(255))
  end

  def draw
    $game.draw_rect(@x, @y, @width, @height, @color)
  end

  def colision?(dot)
    (@x..@x + @width).cover?(dot.x) && (@y..@y + @height).cover?(dot.y)
  end
end
