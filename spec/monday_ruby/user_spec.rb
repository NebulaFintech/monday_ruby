RSpec.describe MondayRuby::User do
  let(:configuration) { YAML.load_file(file_fixture('configuration.yml')) }
  let(:users) { JSON.parse(File.open(file_fixture('users.json')).read) }

  before do
    MondayRuby.configure do |config|
      config.api_key = configuration['api_key'] || 'my_api_key'
    end
  end

  it 'gets users' do
    allow_any_instance_of(MondayRuby::Requestor).to receive(:request).and_return(users)
    users = MondayRuby::User.all

    expect(users).to be_a(Array)
    expect(users.count).to be > 1
    expect(users.first).to be_a(MondayRuby::User)
  end
end
