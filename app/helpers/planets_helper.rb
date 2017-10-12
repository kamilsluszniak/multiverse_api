module PlanetsHelper
  class PlanetObject
    attr_accessor :lvl
    attr_accessor :name
    attr_accessor :time
    attr_accessor :cost

    def initialize
      @lvl = nil
      @name = nil
      @time = nil
      @cost = nil
    end

    def print_cost
      cost = ""
      @cost.each do |key, value|
        cost = cost + key.to_s.capitalize.split("_").first + ": " + value.round(1).to_s
        cost << " "
      end
      return cost
    end

  end
end
