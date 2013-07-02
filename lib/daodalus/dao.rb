require 'delegate'

module Daodalus
  class DAO
    include DSL
    extend Forwardable

    def initialize(db, collection, connection=:default)
      @db         = db
      @collection = collection
      @connection = connection
    end

    def coll
      @coll ||= Daodalus::Connection.fetch(connection).tap do |conn|
        conn.use(db.to_s)
      end[collection.to_s]
    end

    delegate [
      :find,
      :find_and_modify,
      :insert,
      :save,
      :count,
      :aggregate,
      :update
    ] => :coll

    private

    attr_reader :db, :collection, :connection

  end
end
