module Sunspot
  module Query
    class Grouping
      def initialize
        @params = Hash.new do |hash, key|
          [:'group.field', :'group.func'].include?(key) ? [] : nil
        end
      end

      def add_fields(*field_names)
        fields.concat(field_names)
      end

      def add_function(function_query)
        functions << function_query.to_s
      end

      def limit=(limit)
        @params[:'group.limit'] = limit
      end

      def offset=(offset)
        @params[:'group.offset'] = offset
      end

      def order=(sort)
        @params[:'group.sort'] = sort.to_param
      end

      def to_params
        params = @params.merge(:group => true)
        params[:'group.field'] = @fields if @fields
        params[:'group.func'] = @functions if @functions
        params
      end

      def fields
        @fields ||= []
      end

      def functions
        @functions ||= []
      end
    end
  end
end
