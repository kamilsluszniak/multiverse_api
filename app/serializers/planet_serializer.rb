class PlanetSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :metal, :crystal, :hydrogen, :energy, :metal_lvl, :crystal_lvl, :hydrogen_lvl, :solar_lvl,
    :metal_rdy_at, :crystal_rdy_at, :hydrogen_rdy_at, :solar_rdy_at
end
