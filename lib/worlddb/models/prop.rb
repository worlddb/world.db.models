# encoding: utf-8

module WorldDB::Models

  class Prop < ActiveRecord::Base

    def self.create_from_worlddb_fixture!( name, path )
      key   = "db.#{fixture_name_to_prop_key(name)}.version"
    
      if path.starts_with?( WorldDB.data_path )
        value = "world.yml.#{WorldDB::VERSION}"  # assume builtin
      else
        value = "file.txt.#{File.mtime(path).strftime('%Y.%m.%d')}"
      end
    
      Prop.create!( key: key, value: value )
    end
    
private

  # helper
  #   change at/2012_13/bl           to at.2012/13.bl
  #    or    quali_2012_13_europe_c  to quali.2012/13.europe.c
  
  def self.fixture_name_to_prop_key( name )
    prop_key = name.gsub( '/', '.' )
    prop_key = prop_key.gsub( /(\d{4})_(\d{2})/, '\1/\2' )  # 2012_13 => 2012/13
    prop_key = prop_key.gsub( '_', '.' )
    prop_key
  end
    
    
  end  # class Prop

end # module WorldDB::Models