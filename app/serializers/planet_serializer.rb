class PlanetSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :metal, :crystal, :hydrogen, :energy
end
