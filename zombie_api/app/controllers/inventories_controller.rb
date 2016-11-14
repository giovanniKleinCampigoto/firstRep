class InventoriesController < ApplicationController

  # GET /inventories
  def index
    @inventories = Inventory.all

    render json: @inventories
  end

  # POST /inventories
  def create

    @survivor = Survivor.find(params[:survivor_id])
    if(@survivor.infected? == false)
      @inventory = Inventory.create(inventory_params)
      @survivor.inventory = @inventory

      if @inventory.save
        render json: @inventory, status: :created#, location: @inventory
      else
        render json: @inventory.errors, status: :unprocessable_entity
      end
    else
      render json: {"message": "It's infected, cannot complete action!"}, status: 422
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def inventory_params
      params.require(:inventory).permit(:name, :water, :food, :medical_kits, :ammo, :survivor_id)
    end
end
