# Wpcli

Simple wrapper for wp-cli (http://wp-cli.org/).

Just pass commands (http://wp-cli.org/commands/) to run method and use returned hash as you wish.

## Installation

Add this line to your application's Gemfile:

    gem 'wpcli', "~> 0.2.0"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wpcli

## Rails

Simplest way to use in rails is to create config file and use methods from module.

Generate example config

    rails g wpcli:config

Generated file (config/wpcli.yml)

    apps:
        key_for_installation: /absolute/path/for/my/wp-installation

In controller include module

    class MyController < ApplicationController
      include Wpcli

And then you can use client with key:

     users = wpcli(:key_for_installation).run "user list"


You can check if there is any apps in config with

    wp_apps?

## Alternative way

If you like to use client for example in command line, you can create instance with path of wordpress installation

    @wpcli = Wpcli::Client.new "path/to/wp"
    users = @wpcli.run "user list"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![Gem Version](https://badge.fury.io/rb/wpcli.png)](http://badge.fury.io/rb/wpcli) [![Build Status](https://travis-ci.org/hasanen/wpcli.png?branch=master)](https://travis-ci.org/hasanen/wpcli)
