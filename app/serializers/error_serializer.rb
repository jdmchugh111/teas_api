class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def serialize_json
    {
      errors: [
        {
          code: @error_object.status_code,
          message: @error_object.message
        }
      ]
    }
  end
end