# encoding: UTF-8

module WorldDb


class ReaderBase

  include LogUtils::Logging

## make models available in sportdb module by default with namespace
#  e.g. lets you use City instead of Models::City
  include Models
  include Matcher  # e.g. match_cities_for_country, match_regions_for_country, etc.

## value helpers e.g. is_year?, is_taglist? etc.
  include TextUtils::ValueHelper


  def skip_tags?()   @skip_tags == true;  end
  def strict?()      @strict == true;     end


  def initialize( opts={} )
    ## option: do NOT generate/add any tags for countries/regions/cities
    @skip_tags =  opts[:skip_tags].present? ? true : false
    ## option: for now issue warning on update, that is, if key/record (country,region,city) already exists
    @strict    =  opts[:strict].present? ? true : false
  end


  def load_setup( name )
    reader = create_fixture_reader( name )

    reader.each do |fixture|
      load( fixture )
    end
  end # method load_setup


  def load( name )

    if name =~ /^continents/
       load_continent_defs( name )
    elsif name =~ /\/continents/
       load_continent_refs( name )
    elsif name =~ /^lang/
       ## todo: pass along opts too
       ## use match_usage( name ) - why? why not?? ???
       r = create_lang_reader( name )
       r.read()
    elsif name =~ /\/lang/
       ## todo: pass along opts too
       ## use match_usage( name ) - why? why not?? ???
       r = create_usage_reader( name )
       r.read()
    elsif name =~ /\/fifa/
       load_xxx( 'fifa', name )
    elsif name =~ /\/iso3/
       load_xxx( 'iso3', name )
    elsif name =~ /\/internet/
       load_xxx( 'net', name )
    elsif name =~ /\/motor/
       load_xxx( 'motor', name )
    elsif name =~ /^tag.*\.\d$/
       ## todo: pass along opts too
       ## use match_tags( name ) - why? why not?? ???
       
       ######## FIX: add back again
       ### fix: use read() only, that is, w/o name
       ## r = create_tag_reader( name )
       ## r.read()
    elsif match_countries_for_continent( name ) do |continent|  # # e.g. africa/countries or america/countries
            ### NB: continent changed to regions (e.g. middle-east, caribbean, north-america, etc.)
            ## auto-add continent (from folder structure) as tag
            ## fix: allow dash/hyphen/minus in tag

            ### todo/fix: add opts - how??
            r = create_country_reader( name, tags: continent.tr('-', '_') )
            r.read()
          end
    elsif match_cities_for_country( name ) do |country_key|  #  name =~ /\/([a-z]{2})\/cities/
            ## auto-add required country code (from folder structure)
            country = Country.find_by_key!( country_key )
            logger.debug "Country #{country.key} >#{country.title} (#{country.code})<"

            r = create_city_reader( name, country_id: country.id )
            r.read()
          end
    elsif match_regions_abbr_for_country( name ) do |country_key|   # name =~ /\/([a-z]{2})\/regions\.abbr/
            load_regions_xxx( country_key, 'abbr', name )
          end
    elsif match_regions_iso_for_country( name ) do |country_key|  # name =~ /\/([a-z]{2})\/regions\.iso/
            load_regions_xxx( country_key, 'iso', name )
          end
    elsif match_regions_nuts_for_country( name ) do |country_key|  # name =~ /\/([a-z]{2})\/regions\.nuts/
            load_regions_xxx( country_key, 'nuts', name )
          end
    elsif match_regions_for_country( name ) do |country_key|  # name =~ /\/([a-z]{2})\/regions/
            ## auto-add required country code (from folder structure)
            country = Country.find_by_key!( country_key )
            logger.debug "Country #{country.key} >#{country.title} (#{country.code})<"

            r = create_region_reader( name, country_id: country.id )
            r.read()
          end
    else
      logger.error "unknown world.db fixture type >#{name}<"
      # todo/fix: exit w/ error
    end
  end


  ### use RegionAttrReader
  def load_regions_xxx( country_key, xxx, name )
    country = Country.find_by_key!( country_key )
    logger.debug "Country #{country.key} >#{country.title} (#{country.code})<"

    reader = create_hash_reader( name )

    reader.each do |key, value|
      region = Region.find_by_country_id_and_key!( country.id, key )
      region.send( "#{xxx}=", value )
      region.save!
    end
  end


  ### use ContinentRefReader
  def load_continent_refs( name )
    reader = create_hash_reader( name )

    reader.each do |key, value|
      country = Country.find_by_key!( key )
      continent = Continent.find_by_key!( value )
      country.continent_id = continent.id
      country.save!
    end
  end

  ### use ContinentDef Reader
  def load_continent_defs( name, more_attribs={} )
    reader = create_values_reader( name, more_attribs )

    reader.each_line do |attribs, values|

      ## check optional values
      values.each_with_index do |value, index|
        logger.warn "unknown type for value >#{value}<"
      end

      rec = Continent.find_by_key( attribs[ :key ] )
      if rec.present?
        logger.debug "update Continent #{rec.id}-#{rec.key}:"
      else
        logger.debug "create Continent:"
        rec = Continent.new
      end
      
      logger.debug attribs.to_json
   
      rec.update_attributes!( attribs )

    end # each lines
  end # load_continent_defs

  ### use CountryAttr Reader
  def load_xxx( xxx, name )
    reader = create_hash_reader( name )

    reader.each do |key, value|
      country = Country.find_by_key!( key )
      country.send( "#{xxx}=", value )
      country.save!
    end
  end

end # class ReaderBase
end # module WorldDb
