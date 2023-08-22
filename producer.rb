require 'bunny'

puts "Connecting to Rabbit"
conn = Bunny.new('amqp://guest:guest@rabbit:5672')
conn.start

puts "Creating channel"
ch = conn.create_channel

puts "Declaring exchange"
x = ch.topic("example.exchange")

puts "Beginning to publish messages"
1.step do |i|
  x.publish("Message #{i}")
  sleep 0.01
end

