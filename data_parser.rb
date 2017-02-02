require 'csv'

class Delivery

  attr_accessor :pilot, :destination, :what_got_shipped, :number_of_crates, :money_we_made

  def initialize(destination:, what_got_shipped:, number_of_crates:, money_we_made:)
    @destination      = destination.to_s
    @what_got_shipped = what_got_shipped.to_s
    @number_of_crates = number_of_crates.to_i
    @money_we_made    = money_we_made.to_f
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

# deliveries.each do |delivery|
#   case delivery.destination
#   when "Earth"
#     pilots["Fry"] << [delivery.destination, delivery.money_we_made]
#   when "Mars"
#     pilots["Amy"] << [delivery.destination, delivery.money_we_made]
#   when "Uranus"
#     pilots["Bender"] << [delivery.destination, delivery.money_we_made]
#   else
#     pilots["Leela"] << [delivery.destination, delivery.money_we_made]
#   end
# end

weekly_income = daily_income.inject(0){|sum,item| sum + item}
# puts weekly_income
# puts pilots.inspect





  #
