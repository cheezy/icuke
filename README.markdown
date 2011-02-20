iCuke
=====

iCuke allows you to test an iPhone application with cucumber. It provides a selection of step definitions similar to
those provided for testing web applications.

Usage
-----

Install the gem, require it, and extend your cucumber World object with
the iCuke step definitions, in a cucumber support file:

    require 'icuke/cucumber'
    World(ICukeWorld)

Write some scenarios like:

    Background:
      Given "iCuke" from "app/iCuke/iCuke.xcodeproj" is loaded in the simulator

    Scenario: User views the About screen
      When I tap "About"
      Then I should see "Author:"

How it works
------------

iCuke launches your application into the iPhone Simulator. A preload library is used to add a HTTP server into your
application.

The HTTP server allows us to see an XML version of the iPhone's screen, and to emulate taps/swipes etc.

iCuke should not require any code changes to your application to work, however, it relies on accessibility information to function sensibly. If your accessibility information is not accurate, iCuke may not work as expected.

Compatibility Mode
------------------

By default iCuke adds methods to the World object in which cucumber scenarios run.

This makes it easy to do things like this in your step definitions:

    Given /^the user is logged in$/ do
      type "username", "test_user"
      type "password", "test_password"
    end

In adding things to the World object, however, you may end up stomping on methods that come from other places. For example, Capybara defines a #drag method for the World object, and so does ICuke. This makes it impossbile to use them together. Another example is the #tap method in ICuke which conflicts with Ruby 1.9.X's Object#tap method.

In order to solve this instead of:

    require 'icuke/cucumber'
    World(ICukeWorld)

do

    require 'icuke/cucumber_compat'
    World(ICukeWorld)

By doing this each of the methods provided by the api will be scoped to an icuke_driver object. #tap becomes icuke_driver.tap, #drag becomes icuke_driver.drag, #type becomes icuke_driver.type etc. The example above would become:

    Given /^the user is logged in$/ do
      icuke_driver.type "username", "test_user"
      icuke_driver.type "password", "test_password"
    end

Bugs
----

iCuke does not support testing applications on real devices, because I don't know of a way get a preload library to
load on the device.

iCuke does not support pinches yet. They'll be here soon!

iCuke compiles against the latest 3.1 and 4.0 SDKs it can find. Compiling against 3.2 is not currently supported as Apple have released two versions with different ABIs.

Future development
------------------

The initial development of iCuke was sponsored by Unboxed Consulting. That sponsorship has now ended. In order to help support the future development of iCuke please consider donating.

<a href='http://www.pledgie.com/campaigns/13697'><img alt='Click here to lend your support to: iCuke and make a donation at www.pledgie.com !' src='http://www.pledgie.com/campaigns/13697.png?skin_name=chrome' border='0' /></a>

Contributors
------------

* Nigel Taylor
* Aslak Hellesøy
* Dominic Baggott
* Jeff Morgan
* Luke Redpath
* Grant McInnes

Thanks
------

Thanks go to the people who's work iCuke is based on:

* Matt Gallagher
* Ian Dees
* Felipe Barreto

Note on Patches/Pull Requests
-----------------------------
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010 Unboxed Consulting. See LICENSE for details.
