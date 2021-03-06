require_relative '../../wrappers/Ruby/aergo.rb'

aergo = Aergo.new("testnet-api.aergo.io", 7845)

account = AergoAPI::Account.new
# set the private key
account[:privkey] = "\xCD\xFA\x3B\xF9\x1A\x2C\xB6\x9B\xEC\xB0\x16\x7E\x11\x00\xF6\xDE\x77\xAF\x05\xD6\x4E\xE5\x0C\x2C\xD4\xBA\xDD\x70\x01\xF0\xC5\x4B"
# or use an account on Ledger Nano S
#account[:use_ledger] = true
#account[:index] = 0

ret = aergo.get_account_state(account)

if ret["success"]
  puts "address: " + account[:address]
  puts "nonce  : " + account[:nonce].to_s
  puts "balance: " + account[:balance].to_s
else
  puts "FAILED: " + ret["error"]
end
