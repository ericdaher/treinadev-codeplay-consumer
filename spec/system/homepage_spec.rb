require 'rails_helper'

describe 'Homepage' do
  it 'found codeplay courses' do
    allow(Faraday).to receive(:get).and_return(
      instance_double(Faraday::Response, status: 200, 
                                         body: File.read(Rails.root.join('spec/fixtures/courses.json')))
    )
    
    visit root_path

    expect(page).to have_content('Ruby')
    expect(page).to have_content('Ruby on Rails')
    expect(page).to have_content('Peter Capaldi')
  end

  it 'found codeplay courses' do
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/courses').and_raise(Faraday::ConnectionFailed)

    visit root_path

    expect(page).to have_content('Ruby')
    expect(page).to have_content('Ruby on Rails')
    expect(page).to have_content('Peter Capaldi')
  end
end