class TestMotor
  include Singleton
  def forward(delay, steps)
    puts "forward delay:#{delay} steps:#{steps}"
    sleep(delay / 1000)
    puts 'done'
  end

  def backwards(delay, steps)
    puts "backwards delay:#{delay} steps:#{steps}"
    sleep(delay / 1000)
    puts 'done'
  end

  def clean_up!
    puts '*' * 80
    puts 'cleaned'
    puts '*' * 80
  end
end

