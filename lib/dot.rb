require './lib/brain'

class Dot
  DEFAULT_SIZE = 3

  attr_reader :x, :y
  attr_accessor :brain, :dead, :highlight

  def self.goal(x = (Game::WIDTH / 2) - 3, y = 10)
    new(x, y, Gosu::Color::GREEN, DEFAULT_SIZE * 2)
  end

  def initialize(x = nil, y = nil, color = nil, size = DEFAULT_SIZE)
    @brain = Brain.new
    @color = color || Gosu::Color::WHITE
    @size = size
    @x = x || (Game::WIDTH / 2) - @size / 2
    @y = y || Game::HEIGHT - 50
    @speed = 5
    @dead = false
    @highlight = false
  end

  def dead?
    @dead == true
  end

  def reached_goal?
    @reached_goal ||= (distance_to_goal <= 15)
  end

  def update(obstacles)
    return if dead? || reached_goal?

    if hit_wall?
      @dead = true
    elsif obstacles.any? { |o| o.colision?(self) }
      @dead = true
    else
      move
    end
  end

  def move
    angle = @brain.next_move

    if angle
      @x += @speed * Math.sin(angle)
      @y += @speed * Math.cos(angle)
    else
      @dead = true
    end
  end

  def draw
    $game.draw_rect(@x, @y, size, size, color, @highlight ? 2 : 1)
  end

  def fitness
    fitness = dead? ? 1000 : 5000

    if reached_goal?
      fitness -= (brain.step * 5)
    else
      fitness -= distance_to_goal
    end

    fitness ** 3
  end

  def make_baby(mutate: true)
    baby = Dot.new
    baby.brain.directions = brain.directions.clone
    baby.brain.step = 0
    baby.mutate if mutate
    baby
  end

  def mutate
    @brain.mutate
  end

  private

  def hit_wall?
    @x <= size || @x >= Game::WIDTH - size ||
      @y <= size || @y >= Game::HEIGHT - size
  end

  def distance_to_goal
    Gosu.distance(@x, @y, $game.goal.x, $game.goal.y).abs
  end

  def size
    if @highlight
      @size * 2
    elsif dead?
      @size * 0.5
    else
      @size
    end
  end

  def color
    if @highlight
      Gosu::Color::GREEN
    elsif dead?
      Gosu::Color::RED
    elsif reached_goal? && @size <= DEFAULT_SIZE
      Gosu::Color::BLUE
    else
      @color
    end
  end
end
