class Brain
  MUTATION_RATE = 0.01

  def initialize(size = 1000)
    @directions = (1..size).map { rand(0..360.0) }
    @step = 0
  end

  attr_accessor :step, :directions

  def next_move
    direction = @directions[@step]
    @step += 1
    direction
  end

  def mutate
    @directions.map! { |d| rand <= MUTATION_RATE ? rand(0..360.0) : d }
  end
end
