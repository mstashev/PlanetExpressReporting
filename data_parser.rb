require 'csv'
class Delivery

  attr_accessor :pilot, :destination, :what_got_shipped, :number_of_crates, :money_we_made

  def initialize(destination:, what_got_shipped:, number_of_crates:, money_we_made:)
    @destination      = destination.to_s
    @what_got_shipped = what_got_shipped.to_s
    @number_of_crates = number_of_crates.to_i
    @money_we_made    = money_we_made.to_i
    @pilot            = setPilot
  end

  def setPilot
    case destination
    when "Earth" then @pilot = "Fry"
    when "Mars" then @pilot = "Amy"
    when "Uranus" then @pilot = "Bender"
    else @pilot = "Leela"
    end
  end

end

daily_income, deliveries = [], []

CSV.foreach("planet_express_logs.csv", headers: true, header_converters: :symbol) do |row|
  delivery = Delivery.new(row)
  puts delivery.inspect
  deliveries << delivery
end

deliveries.each{ |delivery| daily_income << delivery.money_we_made}

def get_pilot_profits(pilot, deliveries)
  shipments = deliveries.select { |delivery| delivery.pilot.include? pilot }
  shipments.collect{|delivery| delivery.money_we_made}.inject(0){|sum,item| sum + item}
end

def get_planet_profits(destination, deliveries)
  shipments = deliveries.select { |delivery| delivery.destination.include? destination }
  shipments.collect{|delivery| delivery.money_we_made}.inject(0){|sum,item| sum + item}
end
pilots = deliveries.flat_map{|delivery| delivery.pilot}.uniq
destinations = deliveries.flat_map{|delivery| delivery.destination}.uniq

profit_by_pilots = pilots.collect { |pilot| {pilot: pilot, profits: get_pilot_profits(pilot, deliveries)}}

profit_by_planets = destinations.collect { |destination| {destination: destination, profits: get_planet_profits(destination, deliveries)}}

weekly_income = daily_income.inject(0){|sum,item| sum + item}

pilots.each { |pilot| puts "#{pilot}'s trips are: #{deliveries.count{|delivery| delivery.pilot == pilot}}" }

profit_by_pilots.each { |profit_by_pilot| puts "#{profit_by_pilot[:pilot]}'s bonus is: #{profit_by_pilot[:profits]*0.1}" }

profit_by_planets.each { |profit_by_planet| puts "#{profit_by_planet[:destination]}'s profits were: #{profit_by_planet[:profits]}" }
