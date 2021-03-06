module ZombieEpidemic
  class World
    def initialize(population_size = 10, map_klass = Map, agent_klass = Agent, stm_klass = StateTransitionMachine)
      @map = map_klass.new(10, 10)
      @stm = StateTransitionMachine.new
      @agents = []
      population_size.times { @agents << Agent.new(@map, @stm) }
      @time = 0
    end

    def run(steps = 24 * 3600 * 2 * 10)
      dirname = "zombie_epidemic_#{Time.now.utc.to_i}"
      Dir.mkdir(dirname)

      digits = steps.to_s.length

      render(dirname, digits)

      steps.times do
        @time += 1
        puts "Time: #{@time}"
        @agents.each_with_index do |agent, index|
          agent.act
          agent.age
        end
        @agents.each_with_index do |agent, index|
          agent.commit
        end
        render(dirname, digits)
        deads = @agents.select{ |agent| agent.state.name == :dead }
        @agents.reject!{ |agent| agent.state.name == :dead }
        if deads
          deads.each do |dead|
            if dead.position
              dead.position.contents = nil
              dead.position = nil
            end
          end if deads
          deads.clear
        end
      end
    end

    private
    def render(directory, digits, dpi = 10)
      map_presenter = MapPresenter.new
      file = File.join(directory, "step_%0#{digits}d.png" % @time)
      
      w = @map.width
      h = @map.height
      map_presenter
        .render(@map)
        .resize(w * dpi, h * dpi)
        .save(file, :fast_rgb)
    end
  end
end