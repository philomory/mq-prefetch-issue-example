require 'bunny'

conn = Bunny.new('amqp://guest:guest@rabbit:5672')
conn.start

ch = conn.create_channel

x = ch.topic("example.exchange")
dlx = ch.topic("dlx")

q = ch.quorum_queue('message.queue', durable: true, auto_delete: false, arguments: {"x-delivery-limit" => 2, "x-dead-letter-exchange" => dlx.name})
q.bind(x, routing_key: "#")

dlq = ch.queue('dlq', auto_delete: false)
dlq.bind(dlx, routing_key: '#')

ch.prefetch(1)

q.subscribe(manual_ack: true, block: true) do |delivery_info, properties, payload|
  sleep(rand()*0.06)
  val = rand(10)
  if val == 9
    ch.reject(delivery_info.delivery_tag, true)
  else
    ch.ack(delivery_info.delivery_tag, false)
  end
end
