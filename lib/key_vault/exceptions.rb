module KeyVault
  # Unauthorized Exception
  class Unauthorized < StandardError
    def initialize(msg = 'Not authorised for Azure with supplied credentials')
      super
    end
  end
end
