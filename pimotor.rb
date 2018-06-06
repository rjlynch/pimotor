require 'rpi_gpio'
require 'singleton'

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
Dir[lib + '**/*.rb'].each { |file| require file }


motor = Motor.instance

case ARGV[0]
when ?f then direction = :forward
when ?b then direction = :backwards
else puts 'specify direction (f/b)' && exit
end

motor.send direction ARGV[1].to_i, ARGV[2].to_i
puts 'done'
motor.cleanup!

