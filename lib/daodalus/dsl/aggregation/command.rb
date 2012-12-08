module Daodalus
  module DSL
    module Aggregation
      module Command

        def match(field=nil)
          Match.new(dao, field, {}, to_query)
        end

        def group(*keys)
          Group.new(dao, keys, {}, to_query)
        end

        def limit(total)
          Limit.new(dao, total, to_query)
        end

        def skip(total)
          Skip.new(dao, total, to_query)
        end

        def sort(*fields)
          Sort.new(dao, fields, to_query)
        end

        def unwind(field)
          Unwind.new(dao, field, to_query)
        end

        def project(*fields)
          Project.new(dao, fields, 1, {'_id' => 0}, to_query)
        end

        def to_query
          if to_mongo.empty? then query else query + [to_mongo] end
        end

        private

        def field_as_operator(field)
          if field.is_a?(Fixnum) then field
          elsif field.is_a?(String) || field.is_a?(Symbol) then "$#{field}"
          else field end
        end

        def to_mongo
          raise NotImplementedError, "Including classes must implement this"
        end

        def operator
          raise NotImplementedError, "Including classes must implement this"
        end

        def dao
          raise NotImplementedError, "Including classes must implement this"
        end

        def query
          raise NotImplementedError, "Including classes must implement this"
        end

      end
    end
  end
end