heartbeat_root = File.expand_path(File.dirname(__FILE__))
require heartbeat_root + '/application'

run Heartbeat::Application
