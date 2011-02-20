require 'icuke/icuke_world'

module ICukeWorld

  # Blatantly ripped from Capybara: (http://github.com/jnicklas/capybara)
  #
  # This block rewrites each of the driver methods in ICukeWorld to make
  # them available as "bare" methods on the World object.
  #
  # icuke_driver.screen becomes #screen, for example. icuke_driver.tap
  # becomes #tap.  
  #
  # Obviously this is just syntactic sugar, but isn't that what makes life
  # worth living?
  #
  # The trap with this is that some of the methods produced by this 
  # rewriting may conflict with other methods that are already in the World
  # object. For example, there is a #drag method added by Capybara that
  # conflicts with the #drag method in ICukeWorld.
  #
  # If you're stuck with this conflict, require 'icuke/cucumber_compat' 
  # instead of 'icuke/cucumber' to get the methods still scoped to an
  # icuke_driver object.
  #
  ICuke::SimulatorDriver::DSL_METHODS.each do |method|
    class_eval %Q{
      def #{method}(*args, &block)
        icuke_driver.#{method}(*args, &block)
      end
      }, __FILE__, __LINE__ 
  end

end
