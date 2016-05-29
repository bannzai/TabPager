
Pod::Spec.new do |s|
  s.name = 'PageView'
  s.version = '0.1.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/bannzai/'
  s.summary = 'Paging viewcontroller with top tab bar.'
  s.authors = { 'bannzai' => 'kingkong999yhirose@gmail.com' }
  s.source = { :git => 'https://github.com/bannzai/PageView.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'Classes/*.swift'
  s.resources    = 'Classes/*.xib'
end

