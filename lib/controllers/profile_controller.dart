import '../helpers/user_info.dart';
import '../models/user_model.dart';

// Controller logika bisnis data pengguna
class ProfileController {
  // Mengambil data profil pengguna
  Future<UserModel> getProfileData() async {
    // Memeriksa dan menyimpan token sesi
    final String? token = await UserInfo.getToken();
    if (token == null) {
      await UserInfo.setToken("session_token_124240191");
    }

    return UserModel(
      nama: "Muhammad Ikram Mughni",
      nim: "124240191",
      tempatTanggalLahir: "Banjarmasin, 11 Juli 2006",
      hobi: "Coding, Menonton Film, dan Olahraga",
      fotoUrl: "assets/profile.jpg",
    );
  }
}
