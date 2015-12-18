Pod::Spec.new do |s|
  s.name         = "NerobluCore"
  s.version      = "1.1.0"
  s.summary      = "NeroBlu iOS Core Library."
  s.description  = <<-DESC
                   A longer description of NerobluCore in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
#  s.homepage     = "https://github.com/nakau1/NerobluCore"
#  s.license      = { :type => "Apache License", :file => "LICENSE" }
#  s.author       = { "Nakayasu Yuichi" => "yuichi.nakayasu@gmail.com" }
#  s.ios.deployment_target = "9.0"
  s.frameworks = "Foundation", "UIKit"
  s.dependency 'SwiftyJSON'
  s.source       = { :git => "https://github.com/nakau1/NerobluCore" }
  s.source_files = "NerobluCore/*"
end
