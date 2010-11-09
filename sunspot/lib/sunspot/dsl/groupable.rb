module Sunspot
  module DSL
    module Groupable
      #
      # Group records in the result set.
      #
      def group_by(*field_names, &block)
        group_block = GroupBlock.new(@setup, *field_names)
        Util.instance_eval_or_call(group_block, &block) if block_given?
        @query.add_grouping(group_block.grouping)
      end

      class GroupBlock
        def initialize(setup, *field_names)
          @setup = setup
          @grouping = Query::Grouping.new
          @grouping.add_fields(*field_names)
        end

        attr_reader :grouping

        def field(field_name)
          @grouping.add_fields(field_name)
        end

        include Functional

        def function(&block)
          @grouping.add_function(super)
        end

        def order_by(field_name, direction = nil)
          sort =
            if special = Sunspot::Query::Sort.special(field_name)
              special.new(direction)
            else
              Sunspot::Query::Sort::FieldSort.new(
                @setup.field(field_name), direction
              )
            end

          @grouping.order = sort
        end

        def limit(limit)
          @grouping.limit = limit
        end

        def offset(offset)
          @grouping.offset = offset
        end
      end
    end
  end
end
