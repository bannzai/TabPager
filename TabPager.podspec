
Pod::Spec.new do |s|
  s.name = 'TabPager'
  s.version = '0.1.3'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/bannzai/'
  s.summary = 'Paging viewcontroller with top tab bar.'
  s.authors = { 'bannzai' => 'kingkong999yhirose@gmail.com' }
  s.source = { :git => 'https://github.com/bannzai/TabPager.git', :tag => s.version }

  s.ios.deployment_target = '8.1'
  
  s.source_files = 'Classes/*.swift'
  s.resources    = 'Classes/*.xib'
end

