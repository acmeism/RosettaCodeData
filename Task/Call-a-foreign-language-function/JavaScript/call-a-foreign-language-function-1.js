#include <napi.h>
#include <openssl/md5.h>

#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
using namespace Napi;

Napi::Value md5sum(const Napi::CallbackInfo& info) {
  std::string input = info[0].ToString();

  unsigned char result[MD5_DIGEST_LENGTH];
  MD5((unsigned char*)input.c_str(), input.size(), result);

  std::stringstream md5string;
  md5string << std::hex << std::setfill('0');
  for (const auto& byte : result) md5string << std::setw(2) << (int)byte;
  return String::New(info.Env(), md5string.str().c_str());
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(Napi::String::New(env, "md5sum"),
              Napi::Function::New(env, md5sum));
  return exports;
}

NODE_API_MODULE(addon, Init)
