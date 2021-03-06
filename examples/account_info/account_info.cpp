#include <cstring>
#include "aergo.hpp"

unsigned char privkey[32] = {
  0xCD, 0xFA, 0x3B, 0xF9, 0x1A, 0x2C, 0xB6, 0x9B, 0xEC, 0xB0,
  0x16, 0x7E, 0x11, 0x00, 0xF6, 0xDE, 0x77, 0xAF, 0x05, 0xD6,
  0x4E, 0xE5, 0x0C, 0x2C, 0xD4, 0xBA, 0xDD, 0x70, 0x01, 0xF0,
  0xC5, 0x4B
};

int main() {
  Aergo aergo("testnet-api.aergo.io", 7845);
  aergo_account account = {0};
  char errmsg[256];

  /* load the private key in the account */
  std::memcpy(account.privkey, privkey, 32);
  /* or use the account on Ledger Nano S */
  //account.use_ledger = true;
  //account.index = 0;

  /* get the account state (public key, address, balance, nonce...) */
  if (aergo.get_account_state(&account, errmsg) == true) {
    std::cout << "------------------------------------\n";
    std::cout << "Account address: " << account.address << "\n";
    std::cout << "Account balance: " << account.balance << "\n";
    std::cout << "Account nonce:   " << account.nonce   << "\n";
    //std::cout << "Account state_root: " << account.state_root << "\n";
  } else {
    std::cout << "FAILED to get the account state: " << errmsg << "\n";
  }

  std::cout << "Disconnected\n";
  return 0;
}
