require 'pp'
require 'hoe'
require './lib/worlddb/version.rb'

## NB: plugin (hoe-manifest) not required; just used for future testing/development
### Hoe::plugin :manifest   # more options for manifests (in the future; not yet)


Hoe.spec 'worlddb' do
  
  self.version = WorldDb::VERSION
  
  self.summary = "worlddb - world.db command line tool"
  self.description = summary

  self.urls    = ['https://github.com/geraldb/world.db.ruby']
  
  self.author  = 'Gerald Bauer'
  self.email   = 'opensport@googlegroups.com'
  
  self.extra_deps = [
    ['textutils', '>= 0.5.0'],
    ['commander', '~> 4.1.3'],
    ['activerecord', '~> 3.2']  # NB: will include activesupport,etc.
    ### ['sqlite3',      '~> 1.3']  # NB: install on your own; remove dependency
  ]
  
  self.licenses = ['Public Domain']

  self.spec_extras = {
    :required_ruby_version => '>= 1.9.2'
  }

end

##############################
## for testing 
##
## NB: use rake -I ./lib dev:test      # fresh import (starts w/ clean wipe out)

namespace :worlddb do
  
  BUILD_DIR = "./build"
  
  WORLD_DB_PATH = "#{BUILD_DIR}/world.db"

  DB_CONFIG = {
    :adapter   =>  'sqlite3',
    :database  =>  WORLD_DB_PATH
  }

  directory BUILD_DIR

  task :clean do
    rm WORLD_DB_PATH if File.exists?( WORLD_DB_PATH )
  end

  task :env => BUILD_DIR do
    require 'worlddb'   ### NB: for local testing use rake -I ./lib dev:test e.g. do NOT forget to add -I ./lib
    require 'logutils/db'

    LogUtils::Logger.root.level = :info

    pp DB_CONFIG
    ActiveRecord::Base.establish_connection( DB_CONFIG )
  end

  task :create => :env do
    LogDb.create
    WorldDb.create
  end
  
  task :import => :env do
    WorldDb.read_setup( 'setups/sport.db.admin', '../world.db', skip_tags: true )  # populate world tables
    WorldDb.stats
  end


  desc 'worlddb - build from scratch'
  task :build => [:clean, :create, :import]

  desc 'worlddb - update'
  task :update => [:import]

end  # namespace :worlddb
