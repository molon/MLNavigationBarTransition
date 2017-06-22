Pod::Spec.new do |s|
s.name         = "MLNavigationBarTransition"
s.version      = "0.0.5"
s.summary      = "Advanced navigation bar transition based on official push-pop transition"

s.homepage     = 'https://github.com/molon/MLNavigationBarTransition'
s.license      = { :type => 'MIT'}
s.author       = { "molon" => "dudl@qq.com" }

s.source       = {
:git => "https://github.com/molon/MLNavigationBarTransition.git",
:tag => "#{s.version}"
}

s.platform     = :ios, '7.0'
s.public_header_files = 'Classes/**/*.h'
s.source_files  = 'Classes/**/*.{h,m,c}'
s.requires_arc  = true

end
