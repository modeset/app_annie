module AppAnnie
  class App

    attr_reader :raw,
                :id,
                :status,
                :name,
                :first_sales_date,
                :last_sales_date,
                :icon

    def initialize(attributes)
      @raw = attributes
      @id = attributes['app_id']
      @name = attributes['app_name']
      @status = attributes['status']
      @icon = attributes['icon']
      @first_sales_date = attributes['first_sales_date']
      @last_sales_date = attributes['last_sales_date']
    end

  end
end
