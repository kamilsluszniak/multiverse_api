class Planet < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :system, optional: true
  validates :name, presence: true, allow_blank: false, length: { maximum: 16 }
  before_create :set_ready_to_now
  before_create :update_resources

  def update_resources
    seconds = Time.now - self.resources_updated_at
    self.resources_updated_at = Time.now
    power_consumption = 10*self.metal_lvl*(1.1**self.metal_lvl) + 10*self.crystal_lvl*(1.1**self.crystal_lvl)
      + 20*self.hydrogen_lvl*(1.1**self.hydrogen_lvl)
    efficiency = (self.energy >= power_consumption) ? 1 : (self.energy / power_consumption)
    self.metal = self.metal + self.metal_lvl*(1.1**self.metal_lvl) * 0.0083333 * seconds * efficiency
    self.crystal = self.crystal + self.crystal_lvl*(1.1**self.crystal_lvl) * 0.005555556 * seconds * efficiency
    if self.hydrogen_lvl then
        self.hydrogen = self.hydrogen + self.hydrogen_lvl*(1.1**self.hydrogen_lvl) * 0.00277778 * seconds * efficiency
    end
    self.energy = self.solar_lvl**1.15 * 40
  end

  def update_resources!
    self.update_resources
    self.save!
  end

  def build_metal
    metal = self.metal
    crystal = self.crystal
    lvl = self.metal_lvl
    cost = calc_metal_cost(lvl)
    self.metal = metal - cost[:metal]
    self.crystal = crystal - cost[:crystal]
    self.metal_lvl = lvl + 1
    self.metal_rdy_at = Time.now + building_calc_build_time(cost[:metal], cost[:crystal])
  end

  def build_crystal
    metal = self.metal
    crystal = self.crystal
    lvl = self.crystal_lvl
    cost = calc_crystal_cost(lvl)
    self.metal = metal - cost[:metal]
    self.crystal = crystal - cost[:crystal]
    self.crystal_lvl = lvl + 1
    self.crystal_rdy_at = Time.now + building_calc_build_time(cost[:metal], cost[:crystal])
  end

  def build_hydrogen
    metal = self.metal
    crystal = self.crystal
    lvl = self.hydrogen_lvl
    cost = calc_hydrogen_cost(lvl)
    self.metal = metal - cost[:metal]
    self.crystal = crystal - cost[:crystal]
    self.hydrogen_lvl = lvl + 1
    self.hydrogen_rdy_at = Time.now + building_calc_build_time(cost[:metal], cost[:crystal])
  end

  def build_solar
    metal = self.metal
    crystal = self.crystal
    lvl = self.solar_lvl
    cost = calc_solar_cost(lvl)
    self.metal = metal - cost[:metal]
    self.crystal = crystal - cost[:crystal]
    self.solar_lvl = lvl + 1
    self.solar_rdy_at = Time.now + building_calc_build_time(cost[:metal], cost[:crystal])
  end

  def set_ready_to_now
    self.metal_rdy_at = Time.now
    self.crystal_rdy_at = Time.now
    self.solar_rdy_at = Time.now
    self.hydrogen_rdy_at = Time.now
  end

  def set_updated_to_now
    self.resources_updated_at = Time.now
  end

  def building_calc_build_time(metal_cost, crystal_cost)
    (metal_cost + crystal_cost)/15
  end

  def calc_metal_cost(lvl)
    metal_cost = 60 * 1.5**lvl
    crystal_cost = 45 * 1.5**lvl
    return {:metal => metal_cost, :crystal => crystal_cost}
  end

  def calc_crystal_cost(lvl)
    metal_cost = 48 * 1.6**lvl
    crystal_cost = 23 * 1.6**lvl
    return {:metal => metal_cost, :crystal => crystal_cost}
  end

  def calc_hydrogen_cost(lvl)
    metal_cost = 225 * 1.5**lvl
    crystal_cost = 75 * 1.5**lvl
    return {:metal => metal_cost, :crystal => crystal_cost}
  end

  def calc_solar_cost(lvl)
    metal_cost = 225 * 1.5**lvl
    crystal_cost = 75 * 1.5**lvl
    return {:metal => metal_cost, :crystal => crystal_cost}
  end

end
