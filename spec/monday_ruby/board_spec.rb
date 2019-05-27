RSpec.describe MondayRuby::Board do
  let(:configuration) { YAML.load_file(file_fixture('configuration.yml')) }
  let(:boards) { JSON.parse(File.open(file_fixture('boards.json')).read) }
  let(:board) { JSON.parse(File.open(file_fixture('board.json')).read) }

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

  it 'creates a board with columns and a pulse' do
    allow_any_instance_of(MondayRuby::Requestor).to receive(:request).and_return(board)
    board = MondayRuby::Board.new
    board.name = 'CRM de clientes'
    board.description = 'Administrador de funnels de clientes'
    board.columns = [{ title: 'Responsable', type: 'person' }]
    board.pulses = [{ name: 'Cliente Antonio González López' }]
    
    board.create_with_nested!(user_id: configuration['user_id'] || 123)

    expect(board).to be_a(MondayRuby::Board)
    expect(board.columns).to be_a(Array)
    expect(board.columns.first).to be_a(MondayRuby::Column)
    expect(board.columns.first.title).to eq('Responsable')
    expect(board.pulses).to be_a(Array)
    expect(board.pulses.first).to be_a(MondayRuby::Pulse)
    expect(board.pulses.first.name).to eq('Cliente Antonio González López')
  end
end
