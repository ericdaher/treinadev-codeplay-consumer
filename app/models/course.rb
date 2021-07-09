class Course
  attr_reader :name, :instructor
  def initialize(name:, instructor:)
    @name = name
    @instructor = instructor
  end

  def self.all
    response = Faraday.get 'http://localhost:3000/api/v1/courses'
    courses = JSON.parse(response.body, symbolize_names: true)
    courses.map do |course|
      new(name: course[:name], instructor: course[:instructor])
    end
  rescue Faraday::ConnectionFailed
    []
  end
end