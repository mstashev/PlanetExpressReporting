#!/usr/bin/env ruby
require 'csv'

file_name = ARGV[0]

run_report = ARGV[1]

if run_report == nil
  runPayroll = false
elsif run_report.downcase == "report"
  runPayroll = true
else
  runPayroll = false
end
  # puts runPayroll
class Delivery

  attr_accessor :pilot, :destination, :what_got_shipped, :number_of_crates, :money_we_made

  def initialize( destination:, what_got_shipped:, number_of_crates:, money_we_made: )
    @destination      = destination
    @what_got_shipped = what_got_shipped
    @number_of_crates = number_of_crates.to_i
    @money_we_made    = money_we_made.to_i
    @pilot            = setPilot
    @bonus            = setBonus
  end

  def setPilot
    case destination
    when "Earth"  then @pilot = "Fry"
    when "Mars"   then @pilot = "Amy"
    when "Uranus" then @pilot = "Bender"
    else @pilot   = "Leela"
    end
  end

  def setBonus
    @bonus = money_we_made * 0.1
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

    def self.get_bonuses( symbol, target, deliveries )
      shipments = deliveries.select { |delivery| delivery.send(symbol) == target }
      shipments.collect{ |delivery| delivery.money_we_made }.inject(0){ |sum,item| sum + item } * 0.1
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

  def self.bonus_by_pilots( pilots, deliveries )
    self.pilots( deliveries ).collect { |pilot| { pilot: pilot, bonuses: self.get_bonuses(:pilot, pilot, deliveries) } }
  end

  def self.profit_by_planets( destinations, deliveries )
    self.destinations( deliveries ).collect { |destination| { destination: destination, profits: self.get_profits(:destination, destination, deliveries) } }
  end

  def self.payroll( runPayroll, deliveries )
    if runPayroll == true
      pilothash = []
      pilots( deliveries ).each do |pilot|
        insert = Hash[pilot: pilot, shipment: deliveries.count {|delivery| delivery.pilot == pilot }, revenue: self.get_profits(:pilot, pilot, deliveries), bonus: self.get_profits(:pilot, pilot, deliveries) * 0.1 ]
        pilothash << insert
      end

      CSV.open("accounts.csv", "w") do |csv|
        csv << ["Pilot", "Shipments", "Total Revenue", "Payment"]
        pilothash.each do |hash|
          csv << [hash[:pilot], hash[:shipment], hash[:revenue], hash[:bonus]]
        end
      end
    else
      exit
    end
  end

end

# Variables
deliveries = Parse.new.parse_data(file_name)
pilots = Parse.pilots( deliveries )
destinations = Parse.destinations( deliveries )

#Output to console
puts "Our weekly income was: #{Parse.weekly_income( deliveries )}"
pilots.each { |pilot| puts "#{ pilot } ran #{ deliveries.count{ |delivery| delivery.pilot == pilot } } trip(s)." }
Parse.bonus_by_pilots( pilots, deliveries ).each { |bonus_by_pilot| puts "#{ bonus_by_pilot[:pilot] }'s bonus is: #{ bonus_by_pilot[:bonuses] }" }
Parse.profit_by_planets( destinations, deliveries ).each { |profit_by_planet| puts "#{ profit_by_planet[:destination] }'s profits were: #{ profit_by_planet[:profits] } " }
Parse.payroll( runPayroll, deliveries )
