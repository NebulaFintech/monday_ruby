RSpec.describe MondayRuby::Board do
  let(:configuration) { YAML.load_file(file_fixture('configuration.yml')) }
  let(:boards) { JSON.parse(File.open(file_fixture('boards.json')).read) }

  before do
    MondayRuby.configure do |config|
      config.api_key = configuration['api_key'] || 'my_api_key'
    end
  end

  it 'gets boards' do
    allow_any_instance_of(MondayRuby::Requestor).to receive(:request).and_return(boards)
    boards = MondayRuby::Board.all

    expect(boards).to be_a(Array)
    expect(boards.count).to be > 1
    expect(boards.first).to be_a(MondayRuby::Board)
  end

  it 'creates a board' do
    board = MondayRuby::Board.new
    board.name = 'Cool Board!'
    board.description = 'Board created with MondayRuby'
    board.columns = [{ title: 'name', type: 'name' }, { title: 'Responsable', type: 'person' }]
    board.create!(user_id: configuration['user_id'] || 123)
  end
end
