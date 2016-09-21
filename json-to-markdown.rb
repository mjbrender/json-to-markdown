require "json"
require "erb"
require "uri"
require "pry"
load "pluginentry.rb"

header = "| Name  | Type  | Maintainer | Description | Link | Download |\n" +
         "| :---- | :---- | :--------- | :---------- | :--- | :------- |\n"

table_template = "| <%= name %> | <%= type %> | <%= maintainer %> |" +
                 " <%= description %> | <%= url %> |\n"

renderer = ERB.new(table_template)

# Getting JSON file and parsing it as an array
file = File.read("plugin-metadata-Sept21.json")
plugins = JSON.parse(file)

##
#
# Insert the default information into the catalog
#
##

puts "# Plugin Catalog"
puts "This file is automatically generated. If you would like to add to the plugin list, [add your plugin to this list](link) and it will be added."
puts ""
puts "## All Plugins"
puts header

collectors = []
processors = []
publishers = []

plugins.each do |plugin_hash|
  # prep for initialization of a PluginEntry
  name = plugin_hash["name"]
  type = plugin_hash["type"]
  description = plugin_hash["description"]
  url = plugin_hash["url"]
  maintainer = plugin_hash["maintainer"]

  # determine maintainer type
  maintainer = case url
               when /intelsdi/
                  "Intel"
               when /staples/
                  "Staples Inc"
               else
                  # If it is maintained by someone else,
                  # grab the GitHub organization from its URL
                  URI.split(url)[5].split('/')[1]
               end


  item = PluginEntry.new(name, type, description, url, maintainer)

  case type.downcase
  when /collector/
    collectors.push(item)
  when /processor/
    processors.push(item)
  else
    publishers.push(item)
  end
end

puts "## Collectors"
puts header
collectors.each do |plugin|
  puts output = renderer.result(plugin.get_binding)
end

puts "## Processors"
puts header
processors.each do |plugin|
  puts output = renderer.result(plugin.get_binding)
end

puts "## Publishers"
puts header
publishers.each do |plugin|
  puts output = renderer.result(plugin.get_binding)
end

puts "Want to learn more? lalalalal"
#puts processors.name
#binding.pry
#puts output = renderer.result(item.get_binding)
