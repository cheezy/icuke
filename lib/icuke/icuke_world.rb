require 'nokogiri'

require 'icuke/sdk'
require 'icuke/simulator_driver'

module ICukeWorld
  def icuke_driver
    @icuke_driver ||= ICuke::SimulatorDriver.default_driver(icuke_configuration)
  end
  
  def icuke_configuration
    @icuke_configuration ||= ICuke::Configuration.new({
      :build_configuration => 'Debug'
    })
  end
end

After do
  icuke_driver.quit
end

Given /^(?:"([^\"]*)" from )?"([^\"]*)"(?: with build configuration "([^\"]*)")? is loaded in the (?:(iphone|ipad) )?simulator(?: with SDK ([0-9.]+))?$/ do |target, project, configuration, platform, sdk_version|
  if sdk_version
    ICuke::SDK.use(sdk_version)
  elsif platform
    ICuke::SDK.use_latest(platform.downcase.to_sym)
  else
    ICuke::SDK.use_latest
  end
  attrs = { :target => target,
            :platform => platform,
            :env => {
              'DYLD_INSERT_LIBRARIES' => ICuke::SDK.dylib_fullpath
            }
          }
  attrs.merge!(:build_configuration => configuration) if configuration
  icuke_driver.launch(File.expand_path(project), attrs)
end

Given /^the module "([^\"]*)" is loaded in the simulator$/ do |path|
  path.sub!(/#{File.basename(path)}$/, ICuke::SDK.dylib(File.basename(path)))
  simulator.load_module(File.expand_path(path))
end

Then /^I should see "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, scope|
  raise %Q{Content "#{text}" not found in: #{screen.xml}} unless icuke_driver.screen.visible?(text, scope)
end

Then /^I should not see "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, scope|
  raise %Q{Content "#{text}" was found but was not expected in: #{screen.xml}} if icuke_driver.screen.visible?(text, scope)
end

When /^I tap "([^\"]*)"$/ do |label|
  icuke_driver.tap(label)
end

When /^I type "([^\"]*)" in "([^\"]*)"$/ do |text, textfield|
  icuke_driver.type(textfield, text)
end

When /^I drag from (.*) to (.*)$/ do |source, destination|
  icuke_driver.drag_with_source(source, destination)
end

When /^I select the "(.*)" slider and drag (.*) pixels (down|up|left|right)$/ do |label, distance, direction|
  icuke_driver.drag_slider_to(label, direction.to_sym, distance.to_i)
end

When /^I move the "([^\"]*)" slider to (.*) percent$/ do |label, percent|
  icuke_driver.drag_slider_to_percentage(label, percent.to_i)
end

When /^I scroll (down|up|left|right)(?: to "([^\"]*)")?$/ do |direction, text|
  if text
    icuke_driver.scroll_to(text, :direction => direction.to_sym)
  else
    icuke_driver.scroll(direction.to_sym)
  end
end

When /^I suspend the application/ do
  icuke_driver.suspend
end

When /^I resume the application/ do
  icuke_driver.resume
end

Then /^I put the phone into recording mode$/ do
  icuke_driver.record
end

Then /^show me the screen$/ do
  puts icuke_driver.screen.xml.to_s
end
