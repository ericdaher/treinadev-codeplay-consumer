class Course
  attr_reader :name, :instructor, :code, :description, :price, :enrollment_deadline
  def initialize(name: nil, instructor: nil, code: nil, description: nil, price: nil, enrollment_deadline: nil)
    @name = name
    @instructor = instructor
    @code = code
    @description = description
    @price = price
    @enrollment_deadline = enrollment_deadline&.to_date
  end

  def self.all
    response = Faraday.get 'http://localhost:3000/api/v1/courses'
    return [] unless response.status == 200
  
    courses = JSON.parse(response.body, symbolize_names: true)
    courses.map do |course|
      new(name: course[:name], instructor: course[:instructor], code: course[:code])
    end
  rescue Faraday::ConnectionFailed
    []
  end
  
  def self.find(code)
    response = Faraday.get "http://localhost:3000/api/v1/courses/#{code}"
    course = JSON.parse(response.body, symbolize_names: true)
    new(**course.except(:id, :created_at, :updated_at, :instructor_id))
  end

  def self.create(attributes = {})
    response = Faraday.post(
      'http://localhost:3000/api/v1/courses',
      { course: attributes }.to_json,
      'Content-Type': 'application/json'
    )
    course = JSON.parse(response.body, symbolize_names: true)
    new(**course.except(:id, :created_at, :updated_at, :instructor_id))
  end
end