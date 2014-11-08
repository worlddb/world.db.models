# encoding: UTF-8

module WorldDb

class Reader < ReaderBase

  def initialize( include_path, opts={} )
    super( opts )

    @include_path = include_path
  end

  def create_fixture_reader( name )
    path = "#{@include_path}/#{name}.txt"
    logger.info "parsing data (setup) '#{name}' (#{path})..."

    FixtureReader.from_file( path )
  end

  def create_lang_reader( name )
    path = "#{@include_path}/#{name}.txt"   ## hash reader - use .yml??
    logger.info "parsing data (lang) '#{name}' (#{path})..."

    LangReader.from_file( path )
  end

  def create_usage_reader( name )
    path = "#{@include_path}/#{name}.txt"   ## hash reader - use .yml??
    logger.info "parsing data (usage) '#{name}' (#{path})..."

    UsageReader.from_file( path )
  end

  def create_country_reader( name, more_attribs={} )
    path = "#{@include_path}/#{name}.txt"
    logger.info "parsing data (country) '#{name}' (#{path})..."

    CountryReader.from_file( path, more_attribs )
  end


  def create_tag_reader( name )
    ## fix: change to new from_file() style
    TagDb::TagReader.new( @include_path )
  end



end # class Reader
end # module WorldDb
