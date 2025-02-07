import 'dart:developer';

import '../../../../../domain/core/core.dart';

class ListPenghuniController extends GetxController
    with StateMixin<List<PenghuniModel>> {
  final cSearch = TextEditingController();
  final isSearch = false.obs;
  var items = <PenghuniModel>[];

  void onChange(String value) {
    value.isEmpty ? isSearch.value = false : isSearch.value = true;
    final itemsTrue = items
        .where(
          (e) => e.isAktif == true,
        )
        .toList();
    change(
      value.isEmpty
          ? itemsTrue
          : itemsTrue
              .where((element) => element.nama.toLowerCase().contains(
                    value.toLowerCase(),
                  ))
              .toList(),
      status: RxStatus.success(),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get penghuniStream =>
      ConstansApp.firebaseFirestore
          .collection(ConstansApp.penghuniCollection)
          .snapshots();

  @override
  void onInit() {
    penghuniStream.listen((event) {
      if (event.size == 0) {
        log("empty");
        change(null, status: RxStatus.empty());
      } else {
        items = List.generate(event.docs.length, (index) {
          final data = event.docs[index];
          return PenghuniModel.fromDocumentSnapshot(data);
        });
        log("${items.length}");
        final itemsTrue = items
            .where(
              (e) => e.isAktif == true,
            )
            .toList();
        change(itemsTrue, status: RxStatus.success());
      }
    });
    items.sort((a, b) => a.nama.compareTo(b.nama));
    super.onInit();
  }
}
