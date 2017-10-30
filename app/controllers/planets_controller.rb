class PlanetsController < ApplicationController
  include PlanetsHelper

  before_action :authenticate_user!
  respond_to :json

  def index
    planets = current_user.planets.all
    planets.each { |p| p.update_resources }
    render json: planets
  end

  def planet_info
    @planet = Planet.where('id = ?', params[:id]).first

    if @planet != nil
      if @planet.user_id == current_user.id
        render json: @planet
      else
        @error = t('planet.actions.resources.not_your_planet')
        render :json => { :error => @error }
      end
    else
      @error = t('planet.actions.resources.no_planet')
      render :json => { :error => @error }
    end
  end

  def show_object
    @object = PlanetObject.new
    @object.name = params[:name]
    @planet = Planet.where('id = ?', params[:id]).select([:id, :user_id, query_rdy(@object.name), query_lvl(@object.name)]).first
    if @planet.present?
      if @planet.user_id == current_user.id
        @object.cost = meta_cost_hash(@object.name)
        ready_at = meta_time(@object.name)
        @object.time = (ready_at > Time.now) ? (ready_at - Time.now).to_i : nil
        @object.lvl = meta_lvl(@object.name).to_s
        render json: @object
      else
        @error = t('planet.actions.resources.not_your_planet')
        render :json => { :error => @error }
      end
    else
      @error = t('planet.actions.resources.no_planet')
      render :json => { :error => @error }
    end
  end

  def build_object
    @object = PlanetObject.new
    @object.name = params[:name]
    @planet = Planet.where('id = ?', params[:id]).select([:id, :user_id, :name, :resources_updated_at, :metal, :crystal, :hydrogen, :energy,
      query_rdy(@object.name), :metal_lvl, :crystal_lvl, :hydrogen_lvl, :solar_lvl]).first

    if @planet.present?
      if (@planet.user_id == current_user.id)
        @object.time = meta_time(@object.name).to_s
        if (@object.time <= Time.now)
          @object.cost = meta_cost_hash(@object.name)
          @planet.update_resources
          if (@object.cost[:metal].nil? || (@object.cost[:metal] < @planet.metal)) &&
            (@object.cost[:crystal].nil? || (@object.cost[:crystal] < @planet.crystal)) &&
            (@object.cost[:hydrogen].nil? || (@object.cost[:hydrogen] < @planet.hydrogen)) then

            @object.time = (meta_build(@object.name) - Time.now).to_i
            @object.lvl = meta_lvl(@object.name).to_s

            if @planet.save!
              render json: @planet
            end
          else
            @error = t('common.no-resources')
            render :json => { :error => @error }
          end
        else
          @error = t('common.cooldown')
          render :json => { :error => @error }
        end
      else
        @error = t('planet.actions.resources.not_your_planet')
        render :json => { :error => @error }
      end
    else
      @error = t('planet.actions.resources.no_planet')
      render :json => { :error => @error }
    end
  end

  def research
  end

  def offensive
  end

  def defensive
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def planet_params
        params.require(:planet).permit(:name)
    end

    def query_rdy(object)
      (object + "_rdy_at").to_sym
    end

    def query_lvl(object)
      (object + "_lvl").to_sym
    end

    def meta_cost_hash(name)
      @planet.public_send("calc_#{name}_cost", eval("@planet.#{name}_lvl"))
    end

    def meta_time(name)
      eval("@planet.#{name}_rdy_at")
    end

    def meta_lvl(name)
      eval("@planet.#{name}_lvl")
    end

    def meta_build(name)
      eval("@planet.build_#{name}")
    end
end
