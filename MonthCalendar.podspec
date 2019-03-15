Pod::Spec.new do |s|
s.name        = 'MonthCalendar'
s.version     = '1.0.0'
s.authors     = { 'Pig' => 'zhusongyu1990@163.com' }
s.homepage    = 'https://github.com/zhusongyu/MonthCalendar'
s.summary     = 'a month calendar'
s.source      = { :git => 'https://github.com/zhusongyu/MonthCalendar.git',
:tag => s.version }
s.license     = { :type => "MIT", :file => "LICENSE" }

s.platform = :ios, '9.0'
s.requires_arc = true
s.source_files = 'MonthCalendar/*'
#s.public_header_files = 'PresentViewController.swift'

s.ios.deployment_target = '9.0'
end