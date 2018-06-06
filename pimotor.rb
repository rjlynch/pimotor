lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
Dir[lib + '**/*.rb'].each { |file| require file }

motor = Motor.new

motor.cleanup!

