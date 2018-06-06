class Motor
  include Singleton

  def initialize
    # This apparently differs between pi models but is what is used in the python
    # tutorial I followed
    RPi::GPIO.set_numbering :bcm

    @enable_pin   = 18
    @coil_a_1_pin =  4
    @coil_a_2_pin = 17
    @coil_b_1_pin = 23
    @coil_b_2_pin = 24

    RPi::GPIO.setup @enable_pin,   as: :output, initialize: :high
    RPi::GPIO.setup @coil_a_1_pin, as: :output
    RPi::GPIO.setup @coil_a_2_pin, as: :output
    RPi::GPIO.setup @coil_b_1_pin, as: :output
    RPi::GPIO.setup @coil_b_2_pin, as: :output
  end

  def clean_up!
    RPi::GPIO.reset
  end

  def forward(delay, steps)
    for i in 0..steps do
      set_step_with_delay :high, :low,  :high, :low,  delay: delay
      set_step_with_delay :low,  :high, :high, :low,  delay: delay
      set_step_with_delay :low,  :high, :low,  :high, delay: delay
      set_step_with_delay :high, :low,  :low,  :high, delay: delay
    end
  end

  def backwards(delay, steps)
    (0..steps).each do |step|
      set_step_with_delay :high, :low,  :low,  :high, delay: delay
      set_step_with_delay :low,  :high, :low,  :high, delay: delay
      set_step_with_delay :low,  :high, :high, :low,  delay: delay
      set_step_with_delay :high, :low,  :high, :low,  delay: delay
    end
  end

  private

  def set_step_with_delay(a1, a2, b1, b2, delay:)
    set_step a1, a2, b1, b2
    sleep(delay.to_f / 1000)
  end

  def set_step(a1, a2, b1, b2)
    RPi::GPIO.send "set_#{a1}", @coil_a_1_pin
    RPi::GPIO.send "set_#{a2}", @coil_a_2_pin
    RPi::GPIO.send "set_#{b1}", @coil_b_1_pin
    RPi::GPIO.send "set_#{b2}", @coil_b_2_pin
  end
end
