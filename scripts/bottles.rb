#!/usr/bin/ruby

require 'ostruct'
require 'date'
require 'yaml'
require 'fileutils'

SERVER_DIR_PATH = '..'
CONFIG_DIR_PATH = '../configs'
PLUGIN_DIR_PATH = '../plugins'

bottles_hash = YAML.load_file("#{CONFIG_DIR_PATH}/bottles.yml")
bottles = OpenStruct.new(bottles_hash)

SOURCE_PATH = bottles.source

server = OpenStruct.new(bottles.server)
plugins = bottles.plugins

validation = true

src_server_filename = "#{server.name}-#{server.version}.jar"
src_server_jar_path = "#{SOURCE_PATH}/servers/#{src_server_filename}"
src_plugins_dir_path = "#{SOURCE_PATH}/plugins"

required_plugins = plugins.keys.select { |name| plugins[name].to_s.match(/^(\w*-)?\w+\.\w+(\.\w+)?(-[\w.-]*)*/) }
ignored_plugins = plugins.keys.select { |name| plugins[name].nil? }
valid_plugins = required_plugins.select { |name| File.exists?("#{src_plugins_dir_path}/#{name}-#{plugins[name]}.jar") }
not_found_plugins = required_plugins - valid_plugins

unless File.exists?(src_server_jar_path)
  puts "Error! #{src_server_filename} not found."
  exit
end
puts "Server: #{src_server_filename}"

puts "Plugins:"
if valid_plugins.count > 0
  list = valid_plugins.map {|name| "#{name} #{plugins[name]}"}
  puts "  Valid: \n    - #{list.join("\n    - ")}"
end

if ignored_plugins.count > 0
  puts "  Ignore: \n    - #{ignored_plugins.join("\n    - ")}"
end

if not_found_plugins.count > 0
  puts "  Not Founnd: \n    - #{not_found_plugins.join("\n    - ")}"
  puts "\nvalidation failed, please check version source or config."
  exit
end

puts "\nPassed validation!"

puts "\nTo remove old jar files..."
begin
  server_jar_path = "#{SERVER_DIR_PATH}/server.jar"
  File.delete(server_jar_path) if File.exists?(server_jar_path)
  puts "Deleted server.jar"
rescue
  puts "Error! Can't delete server.jar"
  exit
end

unless Dir.exist?(SERVER_DIR_PATH)
  Dir.mkdir SERVER_DIR_PATH
end

unless Dir.exist?(PLUGIN_DIR_PATH)
  Dir.mkdir PLUGIN_DIR_PATH
end

begin
  exist_plugins = Dir.glob("#{PLUGIN_DIR_PATH}/*.jar")
  exist_plugins.each do |plugin_path|
      File.delete(plugin_path)
  end
  puts "Deleted plugins!"
rescue
  puts "Error! Can't delete #{plugin_path}"
  exit
end

puts "\nTo copy jar files..."
begin
  FileUtils.cp(src_server_jar_path, "#{SERVER_DIR_PATH}/server.jar")
  puts "Copied server.jar!"
rescue
  puts "Error! Can't copy server.jar"
  exit
end

begin
  valid_plugins.each do |name|
    plugin_file_name = "#{name}-#{plugins[name]}.jar"
    FileUtils.cp("#{src_plugins_dir_path}/#{plugin_file_name}", "#{PLUGIN_DIR_PATH}/#{name}.jar")
  end
  puts "Copied valid plugins!"
rescue
  puts "Error! Can't copy #{plugin_path}"
  exit
end

puts "\nTo create lockfile..."
lockfile = {}
lockfile['source'] = bottles.source
lockfile['server'] = bottles.server
lockfile['plugins'] = {}

plugins.each do |name, version|
  next if version.nil?
  lockfile['plugins'][name] = version
end

File.open("#{CONFIG_DIR_PATH}/bottles.lock.yml", 'w') do |f|
  f.write "# Locked at #{DateTime.now()}\n"
  f.write lockfile.to_yaml
end
puts "Created lockfile!"

puts "\nDone!"
