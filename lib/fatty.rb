module Fatty
  class Formatter
    
    MissingParameter = Class.new(StandardError)

    class << self
      
      def formats
        @formats ||= {}
      end
    
      def format(name, options={}, &block)
        formats[name] = Class.new(options[:base] || Fatty::Format, &block)
      end
    
      def render_file(file, params={})
        format = File.extname(file).delete(".").to_sym
        
        File.open(file, formats[format].write_mode || "w") do |f| 
          f << render(format, params)
        end
      end
    
      def render(format, params={})
        validate(format, params)
        
        format_obj = formats[format].new
        format_obj.extend(@helpers) if @helpers
        format_obj.params = params
        format_obj.validate
        format_obj.render
      end
    
      def required_params(*args)
        @required_params = args
      end
      
      def validate(format, params={})
        check_required_params(params)
      end
      
      def helpers(helper_module=nil, &block)
        @helpers = helper_module || Module.new(&block)
      end
      
      private
      
      def check_required_params(params)
        unless (@required_params || []).all? { |k| params.key?(k) }
          raise MissingParameter, "One or more required params is missing"
        end
      end
    end
  end
  
  class Format
    attr_accessor :params 
    
    def validate
    end 
    
    def self.write_mode(mode=nil)
      return @write_mode unless mode
      @write_mode = mode
    end
  end
end
