import 'package:bits_fuser/models/memo_model.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import '../utils/database_helper.dart';

// https://tozny.com/blog/encrypting-strings-in-android-lets-make-better-mistakes/

class MemoHelper{

  final db = new DatabaseHelper();
  final  _salt = 'Ee/aHwc6EfEactQ00sm/0A==';
  final cryptor = new PlatformStringCryptor();

  // Generates key
  Future<String> getHash(String password) async  {
    String generator;
    generator = await cryptor.generateKeyFromPassword(password, _salt);
    return generator; // returns 32 len size string
  }

  // Save encrypted memo into database
  Future<int> save(String title,String inputData,String password,String key) async {
    var generatedKey = await getHash(password);
    var _encrypted = await cryptor.encrypt(inputData, generatedKey.toString());
    return await db.saveMemo(MemoModel(title,_encrypted,key));
  }

  Future<int> update(var memo) async {
    var generatedKey = await getHash(memo["password"]);
    var _encrypted = await cryptor.encrypt(memo["input"], generatedKey.toString());
    var map = Map();
    map["id"] = memo["id"];
    map["title"] = memo["title"];
    map["input"] = _encrypted;
    map["key"] = memo["key"];
    MemoModel memoModel;
    print(memo["input"]);
    memoModel = MemoModel.map(map);
    return await db.updateMemo(memoModel);
  }

  // Key len = 128,192,256
  Future<List> validate(String input,String password)async{
    var generatedKey  = await getHash(password);
    var decrypted;
    try {
      decrypted = await cryptor.decrypt(input, generatedKey.toString());
      return [true,decrypted];
    } on MacMismatchException {
      //print("wrongly decrypted");
      return [false,"wrongly decrypted"];
    }
  }


}