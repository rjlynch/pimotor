require 'bundler/setup'
require 'rpi_gpio'
require 'singleton'
require 'thread'
require 'json'
#require 'byebug'

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
Dir[lib + '**/**/*.rb'].each { |file| require file }

Thread.abort_on_exception = true

use Rack::Reloader, 0

mutex = Mutex.new
motor_thread = Thread.new do
  while true do
    until Instruction.queue.empty?
      instruction = Instruction.queue.shift
      Motor.instance.public_send *instruction.to_a
      mutex.synchronize { Instruction.processed << instruction }
    end
    sleep 1
  end
end

run Server

at_exit do
  Motor.instance.clean_up!
end
