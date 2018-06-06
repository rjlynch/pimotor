class Motor
  include Singleton

  def initialize
    # This apparently differs between pi models but is what is used in the python
    # tutorial I followed
    RPi::GPIO.set_numbering :bcm

    ENABLE_PIN   = 18
    COIL_A_1_PIN =  4
    COIL_A_2_PIN = 17
    COIL_B_1_PIN = 23
    COIL_B_2_PIN = 24

    RPi::GPIO.setup ENABLE_PIN,   as: :output, initialize: :high
    RPi::GPIO.setup COIL_A_1_PIN, as: :output
    RPi::GPIO.setup COIL_A_2_PIN, as: :output
    RPi::GPIO.setup COIL_B_1_PIN, as: :output
    RPi::GPIO.setup COIL_B_2_PIN, as: :output
  end

  def cleanup!
    RPi::GPIO.clean_up
  end

  def forward(delay, steps)
    (0..steps).each do |step|
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
    sleep(delay / 1000)
  end

  def set_step(a1, a2, b1, b2)
    RPi::GPIO.send "set_#{a1}", COIL_A_1_PIN
    RPi::GPIO.send "set_#{a2}", COIL_A_2_PIN
    RPi::GPIO.send "set_#{b1}", COIL_B_1_PIN
    RPi::GPIO.send "set_#{b2}", COIL_B_2_PIN
  end
end
