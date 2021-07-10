#!/usr/bin/ruby

require 'ostruct'
require 'date'
require 'yaml'
require 'fileutils'

class File
  # Does a case-sensitive check for file existence.
  # Unlike the normal File.definitely_exists? method on OS X with its case-insensitive-by-default FS
  def self.definitely_exists? path
    folder = File.dirname path
    filename = File.basename path
    # Unlike Ruby IO, ls, and find -f, this technique will fail to locate the file if the case is wrong:
    not %x( find "#{folder}" -name "#{filename}" ).empty?
  end
end

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

# [ServerType-]<SemanticVersionNumber>[-Phase][-BuildVersion]
#   ServerType: bukkit, spigot, bungeecord, paper, build
#   Phase: alpha, beta, rc, dist, SNAPSHOT
#   BuildVersion: pipeline number, git commit hash
version_convension = /^(\w+-)?(\d+)(\.\d+)(\.\d+)?((-\w+)(-\w+)?)?/

no_version_plugins = plugins.keys.select { |name| plugins[name].nil? }
valid_plugins = plugins.keys.select { |name| plugins[name].to_s.match(version_convension) }
invalid_plugins = plugins.keys - valid_plugins - no_version_plugins
exist_plugins = valid_plugins.select { |name| File.definitely_exists?("#{src_plugins_dir_path}/#{name}-#{plugins[name]}.jar") }
not_found_plugins = valid_plugins - exist_plugins

unless File.definitely_exists?(src_server_jar_path)
  puts "Error! #{src_server_filename} not found."
  exit
end
puts "Server: #{src_server_filename}"

exist_proportion = "#{valid_plugins.count}/#{plugins.keys.count}"
puts "Plugins: (#{exist_proportion})"
if exist_plugins.count > 0
  list = exist_plugins.map {|name| "#{name}: #{plugins[name]}"}
  puts "  Exist: (#{exist_plugins.count})\n    - #{list.join("\n    - ")}"
end

if not_found_plugins.count > 0
  list = not_found_plugins.map {|name| "#{name}: #{plugins[name]}"}
  puts "  Not Found: (#{not_found_plugins.count})\n    - #{list.join("\n    - ")}"
end

if invalid_plugins.count > 0
  list = invalid_plugins.map {|name| "#{name}: #{plugins[name]}"}
  puts "  Ignore (invalid version name): (#{invalid_plugins.count})\n    - #{list.join("\n      - ")}"
end

if no_version_plugins.count > 0
  list = no_version_plugins
  puts "  Ignore (empty version name): (#{no_version_plugins.count})\n    - #{list.join("\n      - ")}"
end

validation_result = (not_found_plugins.count == 0)
unless validation_result
  puts "\nvalidation failed, please check version source or config."
  exit
end

puts "\nPassed validation!"

puts "\nTo remove old jar files..."
begin
  server_jar_path = "#{SERVER_DIR_PATH}/server.jar"
  File.delete(server_jar_path) if File.definitely_exists?(server_jar_path)
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
  exist_plugins.each do |name|
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

exist_plugins.each do |name|
  version = plugins[name]
  lockfile['plugins'][name] = version
end

File.open("#{CONFIG_DIR_PATH}/bottles.lock.yml", 'w') do |f|
  f.write "# Locked at #{DateTime.now()}\n"
  f.write lockfile.to_yaml
end
puts "Created lockfile!"

puts "\nDone!"
