Pod::Spec.new do |s|
  s.name             = 'WolfChat'
  s.version          = '0.2.3'
  s.summary          = 'A framework for creating text chat-style interfaces.'
  s.description      = <<-DESC
A framework for creating text chat-style interfaces. Architected to be easy to include custom chat items of any design.
                       DESC

  s.homepage         = 'https://github.com/wolfmcnally/WolfChat'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wolfmcnally' => 'wolf@wolfmcnally.com' }
  s.source           = { :git => 'https://github.com/wolfmcnally/WolfChat.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/wolfmcnally'

  s.swift_version = '4.1'

  s.ios.deployment_target = '11.0'

  s.source_files = 'WolfChat/Classes/**/*'
  s.dependency 'WolfCore', '~> 2.1'
end
