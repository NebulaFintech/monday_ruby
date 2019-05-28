RSpec.describe MondayRuby::Board do
  let(:configuration) { YAML.load_file(file_fixture('configuration.yml')) }
  let(:boards_response) { JSON.parse(File.open(file_fixture('boards.json')).read) }
  let(:board_response) { JSON.parse(File.open(file_fixture('board.json')).read) }
  let(:group_response) { JSON.parse(File.open(file_fixture('group.json')).read) }
  let(:column_response) { JSON.parse(File.open(file_fixture('column.json')).read) }
  let(:pulse_response) { JSON.parse(File.open(file_fixture('pulse.json')).read) }

  before do
    MondayRuby.configure do |config|
      config.api_key = configuration['api_key'] || 'my_api_key'
    end
  end

  it 'gets boards' do
    allow_any_instance_of(MondayRuby::Requestor).to receive(:request).and_return(boards_response)
    boards = MondayRuby::Board.all

    expect(boards).to be_a(Array)
    expect(boards.count).to be > 1
    expect(boards.first).to be_a(MondayRuby::Board)
  end

  it 'creates a board with columns and a pulse' do
    board = MondayRuby::Board.new
    board.name = 'CRM de clientes'
    board.description = 'Administrador de funnels de clientes'

    allow_any_instance_of(MondayRuby::Requestor).to receive(:request).and_return(board_response)
    board.create!(user_id: configuration['user_id'] || 123)
    expect(board).to be_a(MondayRuby::Board)

    allow_any_instance_of(MondayRuby::Requestor).to receive(:request).and_return(group_response)
    board.groups = [{ title: 'Funnels' }]
    expect(board.groups).to be_a(Array)
    expect(board.groups.last).to be_a(MondayRuby::Group)
    expect(board.groups.last.title).to eq('Funnels')
    expect(board.groups.last.id).to be_present

    allow_any_instance_of(MondayRuby::Requestor).to receive(:request).and_return(column_response)
    board.columns = [
      { title: 'Responsable', type: 'person' },
      { title: 'Estatus', type: 'status', labels: {
        '0' => 'invite_sent',
        '1' => 'invite_expired',
        '2' => 'prospect_preapproved',
        '3' => 'prospect_declined',
        '4' => 'preapproval_expired',
        '5' => 'application_submitted',
        '6' => 'application_rejected',
        '7' => 'application_authorized',
        '8' => 'offer_expired',
        '9' => 'contract_signed',
        '10' => 'contract_canceled',
        '11' => 'loan_disbursed'
      }}
    ]
    expect(board.columns).to be_a(Array)
    expect(board.columns.last).to be_a(MondayRuby::Column)
    expect(board.columns.last.title).to eq('Estatus')
    expect(board.columns.last.id).to be_present

    allow_any_instance_of(MondayRuby::Requestor).to receive(:request).and_return(pulse_response)
    board.pulses = [{ name: 'Cliente Antonio González López' }]
    expect(board.pulses).to be_a(Array)
    expect(board.pulses.last).to be_a(MondayRuby::Pulse)
    expect(board.pulses.last.name).to eq('Cliente Antonio González López')
    expect(board.pulses.last.id).to be_present
  end
end
