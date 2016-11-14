class SurvivorsController < ApplicationController
  before_action :set_survivor, only: [:show, :update, :destroy]
  $reported_id = 0
  $reporters
  
  # GET /survivors
  def index
    @survivors = Survivor.all

    render json: @survivors
  end

  # GET /survivors/1
  def show
    render json: @survivor
  end

  # POST /survivors
  def create
    @survivor = Survivor.new(survivor_params)

    if @survivor.save
      render json: @survivor, status: :created, location: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  # PATCH /survivors/1 #new location (5000,-5000)
  def update_location (new_lonlat)
    @survivor.update_attribute(:lonlat, new_lonlat)    
  end
  
  # POST
  def trade ()
    json_hash = JSON.parse(request.raw_post)
    get_trader_id = json_hash['trader_id']

    #get survivor inventory
    @survivor_1 = Survivor.find(params[:id])
    inventory_1 = [@survivor_1.inventory.water,@survivor_1.inventory.food,@survivor_1.inventory.medical_kits, @survivor_1.inventory.ammo]

    #get trader inventory
    @survivor_2 = Survivor.find(get_trader_id)
    inventory_2 = [@survivor_2.inventory.water,@survivor_2.inventory.food,@survivor_2.inventory.medical_kits,@survivor_2.inventory.ammo]

    points_s_1 = 0
    points_s_2 = 0

    items_trade_s_1 = []
    items_trade_s_2 = []

    #calculate trader's worth of items
    if(json_hash['water'] != nil)
      points_s_2 = json_hash['water'] * 4        
      items_trade_s_2[0] = json_hash['water']
    end
    if(json_hash['food'] != nil)
      points_s_2 = points_s_2 + json_hash['food'] * 3
      items_trade_s_2[1] = json_hash['food']
    end
    if(json_hash['medical_kits'] != nil)
      points_s_2 = points_s_2 + json_hash['medical_kits'] * 2
      items_trade_s_2[2] = json_hash['medical_kits']
    end
    if(json_hash['ammo'] != nil)
      points_s_2 = points_s_2 + json_hash['ammo']
      items_trade_s_2[3] = json_hash['ammo']
    end    

    #calculate survivor 1 worth of points
    points_s_1 = inventory_1[0] * 4 + inventory_1[1] * 3 + inventory_1[2] * 2 + inventory_1[3]

    if(points_s_2 > points_s_1)
      render json: {"message": "Survivor can't trade items!"}, status: 422
    else
      points_s_1 = 0
      while points_s_1 != points_s_2
        if(inventory_1[0] != nil && inventory_1[0] != 0)
          1.upto(inventory_1[0]) do |i|           
            items_trade_s_1[0] = i * 4
          end
          points_s_1 = items_trade_s_1[0]
        end

        if(inventory_1[1] != nil && inventory_1[1] != 0)
          1.upto(inventory_1[1]) do |i|          
            items_trade_s_1[1] = i * 3
          end
          points_s_1 += items_trade_s_1[1]
        end

        if(inventory_1[2] != nil && inventory_1[2] != 0)
          1.upto(inventory_1[2]) do |i|            
            items_trade_s_1[2] = i * 2 
          end
          points_s_1 += items_trade_s_1[2]
        end

        if(inventory_1[3] != nil && inventory_1[3] != 0)
          1.upto(inventory_1[3]) do |i|            
            items_trade_s_1[3] = i 
          end
          points_s_1 += items_trade_s_1[3]
        end
      end
     
      if(items_trade_s_1[0] != nil)
        items_trade_s_1[0] = items_trade_s_1[0]/4
      else
        items_trade_s_1[0] = 0
      end
      if(items_trade_s_1[1] != nil)
        items_trade_s_1[1] = items_trade_s_1[0]/3
      else
        items_trade_s_1[1] = 0
      end
      if(items_trade_s_1[2] != nil)
        items_trade_s_1[2] = items_trade_s_1[2]/2
      else
        items_trade_s_1[2] = 0
      end
      if(items_trade_s_1[3] != nil)
        items_trade_s_1[3] = items_trade_s_1[3]
      else
        items_trade_s_1[3] = 0
      end

      trade_1 = []
      trade_2 = []

      #survivor 1 accumulate trades
      trade_1[0] = (inventory_1[0] - items_trade_s_1[0]).abs + items_trade_s_2[0]
      trade_1[1] = (inventory_1[1] - items_trade_s_1[1]).abs + items_trade_s_2[1]
      trade_1[2] = (inventory_1[2] - items_trade_s_1[2]).abs + items_trade_s_2[2]
      trade_1[3] = (inventory_1[3] - items_trade_s_1[3]).abs + items_trade_s_2[3]
      #survivor 2 accumulate trades
      trade_2[0] = (inventory_2[0] - items_trade_s_2[0]).abs + items_trade_s_1[0]
      trade_2[1] = (inventory_2[1] - items_trade_s_2[1]).abs + items_trade_s_1[1]
      trade_2[2] = (inventory_2[2] - items_trade_s_2[2]).abs + items_trade_s_1[2]
      trade_2[3] = (inventory_2[3] - items_trade_s_2[3]).abs + items_trade_s_1[3]

      #trade commit
      @survivor_1.inventory.update_attribute(:water, trade_1[0])    
      @survivor_1.inventory.update_attribute(:food, trade_1[1]) 
      @survivor_1.inventory.update_attribute(:medical_kits, trade_1[2])       
      @survivor_1.inventory.update_attribute(:ammo, trade_1[3])    

      @survivor_2.inventory.update_attribute(:water, trade_2[0])
      @survivor_2.inventory.update_attribute(:food, trade_2[1])
      @survivor_2.inventory.update_attribute(:medical_kits, trade_2[2])
      @survivor_2.inventory.update_attribute(:ammo, trade_2[3])
    end
  
  end


  # POST survivors/2/flag_infected # modificar o arquivo .json para reportar como infectado...
  def flag_infected () 

    flag = JSON.parse(request.raw_post) #infected survivor survivor_flagged.json
    $reported_id = flag['is_infected']
    @reporting_survivor = Survivor.find(params[:id]) # reporting survivor on curl file flag_infected function
    @flagged_survivor = Survivor.find(flag['is_infected'])
    
    if(flag['is_infected'] == @reporting_survivor.id)
      render json: {"message": "A survivor can't flag himself, that is nonsense!"}, status: 422
    else
      if(@reporting_survivor.infected? == true)
        render json: {"message": "Zombie doesen't flag people!"}, status: 422
      end
      if($reporters.empty?)
        $reporters.push(@reporting_survivor.id)
      else        
         if($reporters[0] == @reporting_survivor.id || $reporters[1] == @reporting_survivor.id || $reporters[2] == @reporting_survivor.id)
           render json: {"message": "This survivor already reported!"}, status: 422           
         else            
           if($reported_id != flag['is_infected'])
             $reporters.clear
             $reporters.push(@reporting_survivor.id)
           else
             $reporters.push(@reporting_survivor.id)
             puts($reporters)
             if($reporters.length == 3)
               $reporters.clear
               @flagged_survivor.update_attribute(:infected?, true)
               @flagged_survivor.inventory.destroy
               render json: {"message": " Survivor #{@flagged_survivor.name} is a zombie!"}
             else
               render json: {"message": " #{$reporters.length} Survivors flagged this survivor #{@reported_id}!"}
             end
           end
         end
      end
    end
  end

  # PATCH/PUT /survivors/1
  def update
    if @survivor.update(survivor_params)
      render json: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /survivors/1
  def destroy
    @survivor.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survivor
      @survivor = Survivor.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def survivor_params
      params.require(:survivor).permit(:name, :age, :gender, :lonlat, :infected?)
    end
end
