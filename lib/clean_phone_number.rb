class PhoneNumber
  def initialize(phone_number)
    @phone_number = clean_phone_number(phone_number)
  end

  def to_s
    @phone_number
  end

  def clean_phone_number(phone_number)
    phone_number.scan(/[0-9]/).join('')
  end

  def check_valid_phone_number
    number_length = @phone_number.length
    if number_length < 10
      'Invalid Phone Number'
    elsif number_length == 10
      @phone_number
    elsif number_length == 11
      if @phone_number[0] == '1'
        @phone_number[1..10]
      else
        'Invalid Phone Number'
      end
    else
      'Invalid Phone Number'
    end
  end
end