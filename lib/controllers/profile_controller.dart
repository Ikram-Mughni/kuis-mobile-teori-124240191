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
      nama: "Mahasiswa / Developer",
      nim: "124240191",
      tempatTanggalLahir: "Yogyakarta, 15 Januari 2004",
      hobi: "Coding, Membaca Buku, dan Desain UI/UX",
      fotoUrl: "https://picsum.photos/seed/124240191/300/300",
    );
  }
}
