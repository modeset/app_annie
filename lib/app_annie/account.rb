module AppAnnie
  class Account

    attr_reader :raw,
                :id,
                :name,
                :status,
                :platform,
                :first_sales_date,
                :last_sales_date,
                :publisher_name

    def initialize(attributes)
      @raw = attributes
      @id = attributes['account_id']
      @name = attributes['account_name']
      @status = attributes['account_status']
      @platform = attributes['platform']
      @publisher_name = attributes['publisher_name']
      @first_sales_date = attributes['first_sales_date']
      @last_sales_date = attributes['last_sales_date']
    end

  end
end
