require 'pry'
require 'gosu'
require './lib/population'
require './lib/obstacle'

class Game < Gosu::Window
  WIDTH = 350
  HEIGHT = 400

  attr_reader :goal

  def initialize
    super WIDTH, HEIGHT

    @population = Population.new(1000)
    @goal = Dot.goal
    @obstacles = Array.new(3) { Obstacle.new }
  end

  def update
    if @population.dead?
      @population.natural_selection
    else
      @population.update(@obstacles)
    end
  end

  def draw
    @goal.draw
    @population.draw
    @obstacles.each(&:draw)

    draw_fps
    draw_generation
  end

  private

  def draw_fps
    draw_text("FPS: #{Gosu.fps}", 5, 5)
  end

  def draw_generation
    draw_text("Gen: #{@population.generation}", WIDTH - 110, 5, align: :right, width: 100)
    draw_text("Dead: #{@population.dots.count(&:dead?)}", WIDTH - 110, 20, align: :right, width: 100)
    # draw_text("Fitness: #{@population.highest_fitness}", WIDTH - 110, 35, align: :right, width: 100) if @population.highest_fitness > 0
    draw_text("Max steps: #{@population.max_steps}", WIDTH - 110, 35, align: :right, width: 100) if @population.max_steps > 0 && @population.max_steps < 10000
  end

  def draw_text(text, x, y, options = {})
    Gosu::Image.from_text(text, 15, options).draw(x, y, 0)
  end
end

$game = Game.new
$game.show
