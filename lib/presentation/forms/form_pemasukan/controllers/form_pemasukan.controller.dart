import 'dart:developer';
import 'dart:io';

import '/domain/core/core.dart';

class FormPemasukanController extends GetxController
    with StateMixin<List<KamarModel>> {
  final methodApp = MethodApp();
  final formKey = GlobalKey<FormState>();
  final jenisC = TextEditingController();
  final kamarC = TextEditingController();
  final idrC = TextEditingController();
  final waktuC = TextEditingController();
  List<KamarModel> listKamarTerisi = [];

  final listJenis = [
    'Air',
    'Listrik',
  ];

  Future alartJenis() async {
    await alertFormJenis(
      title: "Jenis Pemasukan",
      listValue: listJenis,
      textC: jenisC,
    );
  }

  Future alartKamar(List<KamarModel> listKamar) async {
    await alertFormKamar(
      title: "Kamar",
      listValue: listKamar,
      textC: kamarC,
    );
  }

  Future addPemasukan() async {
    try {
      if (formKey.currentState!.validate()) {
        final dataImage = Get.find<ImagesPemasukanController>();
        if (dataImage.imageFileList.isNotEmpty) {
          final foto = await methodApp.uploadWithImage(
            File(dataImage.imageFileList.first.path),
            "${ConstansApp.idLogin}_${DateTime.now().toIso8601String()}",
          );

          DocumentReference<PenghuniModel> idKamar =
              methodApp.penghuni(kamarC.text);

          DocumentReference<PenghuniModel> idAdmin =
              methodApp.penghuni(ConstansApp.idLogin);

          methodApp.addPemasukan(
            data: PemasukanModel(
              foto: foto,
              jenis: jenisC.text,
              idr: int.parse(idrC.text),
              waktu: waktuC.text,
              idKamar: idKamar,
              idLogin: idAdmin,
              dateUpload: Timestamp.now(),
            ).toMap(),
          );
        } else {
          Get.snackbar('Info', "Tolong tambahkan Image");
        }
      } else {
        Get.snackbar('Info', "Tolong isi semua form");
      }
    } catch (e) {
      Get.snackbar('Info', "Pesan Error : $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get getListKamar =>
      ConstansApp.firebaseFirestore
          .collection(ConstansApp.kamarCollection)
          .where('penghuni', isNotEqualTo: []).snapshots();

  @override
  void onInit() {
    getListKamar.listen((event) {
      if (event.size != 0) {
        listKamarTerisi = List.generate(
          event.docs.length,
          (index) => KamarModel.fromDocumentSnapshot(event.docs[index]),
        ).toList();
        log('${listKamarTerisi.length}', name: 'kamar');
        change(listKamarTerisi, status: RxStatus.success());
      } else {
        log('Kosong', name: 'kamar');
        change([], status: RxStatus.empty());
      }
    });
    super.onInit();
  }
}
