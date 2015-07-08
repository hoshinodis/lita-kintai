require "spec_helper"

describe Lita::Handlers::Kintai, lita_handler: true do
  it { is_expected.to route('kintai') }
  it { is_expected.to route('kintai').to(:kintai) }
  it 'retrieve message "kintai"' do
    kintai_list = %w(あ、チーズ牛丼中盛りツユダクで。)
    send_message('gyudon')
    expect(kintai_list).to include(replies.last)
  end
end
