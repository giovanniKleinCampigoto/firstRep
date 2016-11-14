class StatsController < ApplicationController
  def index

  	render json: {
  		infected_survivors: infected,
  		survivors: non_infected,
  	  avg_resources: avg
  	}

  end

  private

  def infected
  	survivors = Survivor.all.count  	
  	survivors_inf = Survivor.where(infected?: true).count	
  	survivors_inf/survivors
  end

  def non_infected  	
  	survivors = Survivor.all.count  	
  	@survivors_N_inf = Survivor.where(infected?: false).count	
  	@survivors_N_inf/survivors
  end

  def avg 	  	
    temp = 0
  	total_a = 0
  	Inventory.find_each do |inventory|
      temp = inventory.water + inventory.food + inventory.medical_kits + inventory.ammo      
    end
    temp/@survivors_N_inf
  end

end
