require 'rails_helper'

describe 'Homepage' do
  it 'found codeplay courses' do
    allow(Faraday).to receive(:get).and_return(
      instance_double(Faraday::Response, status: 200, body: File.read(Rails.root.join('spec/fixtures/courses.json')))
    )
    
    visit root_path

    expect(page).to have_content('Ruby')
    expect(page).to have_content('Ruby on Rails')
    expect(page).to have_content('Peter Capaldi')
  end

  it 'could not connect to API' do
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/courses').and_raise(Faraday::ConnectionFailed, nil)

    visit root_path

    expect(page).to have_content('Site temporariamente indisponível')
  end

  it 'and API returns 500' do
    allow(Faraday).to receive(:get).and_return(
      instance_double(Faraday::Response, status: 500, body: '')
    )

    visit root_path

    expect(page).to have_content('Site temporariamente indisponível')
  end

  it 'click on course details' do
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/courses').and_return(
      instance_double(Faraday::Response, status: 200, body: File.read(Rails.root.join('spec/fixtures/courses.json')))
    )
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/courses/RUBYRAILS').and_return(
      instance_double(Faraday::Response, status: 200, body: File.read(Rails.root.join('spec/fixtures/course.json')))
    )
    
    visit root_path
    click_on 'Ruby on Rails'

    expect(page).to have_content('Ruby on Rails')
    expect(page).to have_content('Um curso de Ruby on Rails')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('09/10/2021')
    expect(page).to have_content('RUBYRAILS')
  end

  it 'creates a course' do
    allow(Faraday).to receive(:get).and_return(
      instance_double(Faraday::Response, status: 200, body: '[]')
    )
    allow(Faraday).to receive(:post).and_return(
      instance_double(Faraday::Response, status: 201, body: File.read(Rails.root.join('spec/fixtures/course.json')))
    )

    visit root_path
    click_on 'Registrar um novo curso'

    fill_in 'Nome', with: 'Ruby on Rails'
    fill_in 'Descrição', with: 'Um curso de Ruby on Rails'
    fill_in 'Preço', with: '20'
    fill_in 'Código', with: 'RUBYRAILS'
    fill_in 'Data limite de matrícula', with: '09/10/2021'
    fill_in 'Instructor ID', with: '1'
    # select 'Jane Doe', from: 'Instrutor'
    click_on 'Enviar'

    expect(page).to have_content('Ruby on Rails')
    expect(page).to have_content('Um curso de Ruby on Rails')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('09/10/2021')
    expect(page).to have_content('RUBYRAILS')
  end
end