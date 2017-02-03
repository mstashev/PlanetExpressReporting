#!/usr/bin/env ruby
require 'csv'

file_name = ARGV[0]

class Delivery

  attr_accessor :pilot, :destination, :what_got_shipped, :number_of_crates, :money_we_made

  def initialize( destination:, what_got_shipped:, number_of_crates:, money_we_made: )
    @destination      = destination
    @what_got_shipped = what_got_shipped
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

class Parse

  def parse_data( file_name )
    deliveries = []
    CSV.foreach(file_name, headers: true, header_converters: :symbol) do |row|
      delivery = Delivery.new( row )
      deliveries << delivery
    end
    deliveries
  end

  def self.get_profits( symbol, target, deliveries )
    shipments = deliveries.select { |delivery| delivery.send(symbol) == target }
    shipments.collect{ |delivery| delivery.money_we_made }.inject(0){ |sum,item| sum + item }
  end

  def self.weekly_income( deliveries )
    daily_income = []
    deliveries.collect{ |delivery| daily_income << delivery.money_we_made }
    daily_income.inject(0){ |sum,item| sum + item }
  end

  def self.pilots( deliveries )
    deliveries.flat_map{ |delivery| delivery.pilot }.uniq
  end

  def self.destinations( deliveries )
    deliveries.flat_map{ |delivery| delivery.destination }.uniq
  end

  def self.profit_by_pilots( pilots, deliveries )
    self.pilots( deliveries ).collect { |pilot| { pilot: pilot, profits: self.get_profits(:pilot, pilot, deliveries) } }
  end

  def self.profit_by_planets( destinations, deliveries )
    self.destinations( deliveries ).collect { |destination| { destination: destination, profits: self.get_profits(:destination, destination, deliveries) } }
  end

end

deliveries = Parse.new.parse_data(file_name)

puts Parse.weekly_income( deliveries )

Parse.pilots( deliveries ).each { |pilot| puts "#{ pilot }'s trips are: #{ deliveries.count{ |delivery| delivery.pilot == pilot } }" }

Parse.profit_by_pilots( Parse.pilots( deliveries ), deliveries ).each { |profit_by_pilot| puts "#{ profit_by_pilot[:pilot] }'s bonus is: #{ profit_by_pilot[:profits]*0.1 }" }

Parse.profit_by_planets( Parse.destinations( deliveries ), deliveries ).each { |profit_by_planet| puts "#{ profit_by_planet[:destination] }'s profits were: #{ profit_by_planet[:profits] } " }
