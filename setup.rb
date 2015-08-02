require_relative 'simple_chat/simple_chat'

$data = {}
name = nil
server_uri = nil

def save
  File.open('config.yml').write($data.to_yaml)
end

while name == nil || name == "" do
  print "AI name>"
  name = gets.chomp
end

while server_uri == nil || server_uri == "" do
  print "AI Server URI>"
  server_uri = gets.chomp
end

$data['server_uri'] = server_uri
$scc = SimpleChatClient.new(server_uri)
$scc.onconnect do
  puts "connected."
  $scc.new_user(name)
end

$scc.onlogin do |udata|
  puts "success."
  $data['id'] = udata['id']
  $data['ai_name'] = udata['name']
  ai_path = nil
  while ai_path == nil || ai_path == "" do
    print "AI path>"
    ai_path = gets.chomp
  end
  $data['ai_path'] = ai_path
  save
  exit
end

$scc.onerror do |mes|
  if mes == "The Username is already exist" then
    puts "failure!"
    name = nil
    while name == nil || name == "" do
      print "AI name>"
      name = gets.chomp
    end
    $scc.new_user(name)
  end
end

loop do
end
