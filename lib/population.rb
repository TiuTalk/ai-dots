require './lib/dot'

class Population
  def initialize(size)
    @size = size
    @dots = Array.new(@size) { Dot.new }
    @max_steps = Float::INFINITY
    @generation = 0
    @highest_fitness = 0
  end

  attr_reader :generation, :dots, :max_steps, :highest_fitness

  def update(obstacles)
    @dots.each do |dot|
      if dot.brain.step > @max_steps
        dot.dead = true
      else
        dot.update(obstacles)
      end
    end
  end

  def draw
    @dots.each(&:draw)
  end

  def dead?
    @dots.all? { |d| d.dead? || d.reached_goal? }
  end

  def natural_selection
    @fitness_sum = nil
    @best_dot = nil
    @highest_fitness = @dots.map(&:fitness).max.round(2)
    @generation += 1

    new_dots = Array.new(@size) { select_parent.make_baby }

    if best_dot
      @max_steps = [best_dot.brain.step, @max_steps].min
      dot = best_dot.make_baby(mutate: false)
      dot.highlight = true
      new_dots << dot
    end

    @dots = new_dots
  end

  def mutate
    @dots.each(&:mutate)
  end

  private

  def fitness_sum
    @fitness_sum ||= @dots.map(&:fitness).sum.to_f
  end

  def best_dot
    @best_dot ||= @dots.select(&:reached_goal?).max_by(&:fitness)
  end

  def select_parent
    random_fitness = rand(0.0..fitness_sum)

    @dots.shuffle.each do |dot|
      return dot if random_fitness < dot.fitness

      random_fitness -= dot.fitness
    end
  end
end
