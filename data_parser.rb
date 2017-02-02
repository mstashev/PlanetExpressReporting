require 'csv'

class Delivery

  attr_accessor :dest, :shipped_item, :num_crates, :money_made

  def initialize(dest, shipped_item, num_crates, money_made)
    @dest = dest
    @shipped_item = shipped_item
    @num_crates = num_crates
    @money_made = money_made
  end

end

class Pilot

  attr_accessor :name, :route, :bonus, :trips

  def initialize(name, route, bonus, trips)
    @name = name
    @route = route
    @bonus = bonus
    @trips = trips
  end

  def add_trip
    @trip = trip + 1
  end

  def total_bonus(trip_bonus)
    @bonus = trip_bonus.inject(0){|sum,item| sum + item}
  end



end
