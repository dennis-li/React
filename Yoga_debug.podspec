Pod::Spec.new do |s|
  s.name         = "Yoga_debug"
s.version      = "0.47.1.5"
  s.summary      = "Yoga_debug"
  s.description  = <<-DESC
	                    React description.
			                       DESC
  s.homepage     = "https://scm.qiyi.domain/#/admin/projects/mobile-ios/pods/React"
  s.license      = { :type => 'MIT', :text => <<-LICENSE
							                       LICENSE
										                          }

  s.author       = { "Dennis Lee" => "lixu.dennislee@gmail.com" }

  s.platform     = :ios
  s.ios.deployment_target = '7.0'

  s.source       = { :git => "https://github.com/dennis-li/React.git", :tag => s.version }

  s.source_files = 'YogaInclude/*.h'
  s.public_header_files = 'YogaInclude/*.h'
#  s.resources = ['React.xcassets']

# s.dependency 'Yoga_debug'

 s.framework = 'SystemConfiguration'
 s.preserve_paths = 'YogaDebug'
 s.ios.vendored_libraries = 'YogaDebug/libYoga.a'
					         
 s.library = 'c++'

 s.requires_arc = false
			
  end

